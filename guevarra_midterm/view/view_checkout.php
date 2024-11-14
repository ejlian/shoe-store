<?php
session_start();
require_once(__DIR__ . '/../classes/connection.php');

if (!isset($_SESSION['user_id'])) {
    header("Location: view_login.php");
    exit();}

try {
    $stmt = $connection->prepare("
        SELECT ci.*, s.name, s.price, s.image, s.size 
        FROM cart_items ci 
        JOIN shoes s ON ci.shoe_id = s.id 
        WHERE ci.user_id = ?");
    $stmt->execute([$_SESSION['user_id']]);
    $cartItems = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    $total = array_reduce($cartItems, function($sum, $item) {
        return $sum + ($item['price'] * $item['quantity']); }, 0);
} catch (Exception $e) {
    error_log($e->getMessage());
    $cartItems = [];
    $total = 0;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $connection->beginTransaction();
        $shipping_address = $_POST['street'] . ', ' . $_POST['barangay'] . ', ' . $_POST['city'];
        $stmt = $connection->prepare(" INSERT INTO orders ( user_id, shipping_address, phone, payment_method,  delivery_method,   order_status,total_amount, delivery_fee
            ) VALUES (?, ?, ?, ?, ?, 'Pending', ?, ?)");
        $delivery_fee = ($_POST['delivery_method'] === 'express') ? 15.00 : 5.00;
    
        $total_with_shipping = $total + $delivery_fee;

        $stmt->execute([
            $_SESSION['user_id'],
            $shipping_address,
            $_POST['phone'],
            $_POST['payment_method'],
            $_POST['delivery_method'] ?? 'standard',
            $total_with_shipping,
            $delivery_fee
        ]);

        $order_id = $connection->lastInsertId();

        $stmt = $connection->prepare("
            INSERT INTO order_items (order_id, shoe_id, quantity, price) 
            VALUES (?, ?, ?, ?)");

        foreach ($cartItems as $item) {
            $stmt->execute([
                $order_id,
                $item['shoe_id'],
                $item['quantity'],
                $item['price']
            ]);
        }

        foreach ($cartItems as $item) {
            $updateStockStmt = $connection->prepare("
                UPDATE shoes 
                SET stock = stock - ? 
                WHERE id = ? AND stock >= ?
            ");
            $updateStockStmt->execute([
                $item['quantity'],
                $item['shoe_id'],
                $item['quantity']
            ]);
            
            if ($updateStockStmt->rowCount() === 0) {
                throw new Exception("Insufficient stock for item: " . $item['name']);
            }
        }

        $stmt = $connection->prepare("DELETE FROM cart_items WHERE user_id = ?");
        $stmt->execute([$_SESSION['user_id']]);

        $connection->commit();
        
        header("Location: view_thank_you.php");
        exit();

    } catch (Exception $e) {
        $connection->rollBack();
        error_log($e->getMessage());
        $error = "An error occurred while processing your order: " . $e->getMessage();
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout</title>
    <link rel="stylesheet" href="../css/bootstrap.css">
    <link rel="stylesheet" href="../css/variables.css">
    <link rel="stylesheet" href="../css/checkout.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

</head>
<body class="bg-img">
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="view_shoe.php">My Shoe Store</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="view_cart.php">
                            <i class="fas fa-shopping-cart"></i>
                            <span id="cart-count" class="badge bg-danger">0</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="view_logout.php">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8">
                <div class="checkout-container">
                    <h2>Checkout Details</h2>
                    
                    <form method="POST" action="">
                        <div class="mb-3">
                            <label class="form-label">Delivery Address</label>
                            <input type="text" name="street" class="form-control mb-2" placeholder="Street" required>
                            <input type="text" name="barangay" class="form-control mb-2" placeholder="Barangay" required>
                            <input type="text" name="city" class="form-control" placeholder="City" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Phone Number</label>
                            <input type="text" name="phone" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Payment Method</label>
                            <div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="payment_method" id="cod" value="cash_on_delivery">
                                    <label class="form-check-label" for="cod">Cash on Delivery</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="payment_method" id="credit_card" value="credit_card">
                                    <label class="form-check-label" for="credit_card">Credit Card</label>
                                </div>
                            </div>
                        </div>

                        <div id="credit_card_fields" style="display: none;">
                            <div class="mb-3">
                                <label class="form-label">Card Number</label>
                                <input type="text" class="form-control" name="card_number" placeholder="1234 5678 9012 3456">
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label">Expiry Date</label>
                                    <input type="text" class="form-control" name="card_expiry" placeholder="MM/YY">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">CVV</label>
                                    <input type="text" class="form-control" name="card_cvv" placeholder="123">
                                </div>
                            </div>
                        </div>

                        <div id="delivery_method_section" style="display: none;">
                            <div class="mb-3">
                                <label class="form-label">Delivery Method</label>
                                <div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="delivery_method" id="standard" value="standard">
                                        <label class="form-check-label" for="standard">Standard Delivery (₱5.00)</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="delivery_method" id="express" value="express">
                                        <label class="form-check-label" for="express">Express Delivery (₱15.00)</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="delivery_method" id="bike" value="bike">
                                        <label class="form-check-label" for="bike">Bike Delivery (₱8.00)</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">Place Order</button>
                    </form>
                </div>
            </div>

            <div class="col-md-4">
                <div class="checkout-container">
                    <h3 class="mb-3">Order Summary</h3>
                    <div id="orderSummary" class="order-summary">
                        <?php if (empty($cartItems)): ?>
                            <p>Your cart is empty</p>
                            <script>window.location.href = 'view_cart.php';</script>
                        <?php else: ?>
                            <?php foreach ($cartItems as $item): ?>
                                <div class="d-flex align-items-center mb-3">
                                    <img src="../resources/<?php echo htmlspecialchars($item['image']); ?>" 
                                         alt="<?php echo htmlspecialchars($item['name']); ?>"
                                         class="me-2" style="width: 50px; height: 50px; object-fit: cover;">
                                    <div class="flex-grow-1">
                                        <div class="d-flex justify-content-between">
                                            <span><?php echo htmlspecialchars($item['name']); ?></span>
                                            <span class="ms-2">x<?php echo $item['quantity']; ?></span>
                                        </div>
                                        <div class="text-muted">Size: <?php echo htmlspecialchars($item['size']); ?></div>
                                        <div class="text-end">
                                            <span class="text-muted">₱<?php echo number_format($item['price'] * $item['quantity'], 2); ?></span>
                                        </div>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                            
                            <hr>
                            <div class="d-flex justify-content-between">
                                <strong>Subtotal:</strong>
                                <strong>₱<?php echo number_format($total, 2); ?></strong>
                            </div>
                            <div class="d-flex justify-content-between mt-2">
                                <span>Shipping Fee:</span>
                                <span id="shippingFee">₱0.00</span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between">
                                <strong>Total:</strong>
                                <strong id="finalTotal">₱<?php echo number_format($total, 2); ?></strong>
                            </div>
                        <?php endif; ?>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" id="baseTotal" value="<?php echo $total; ?>">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/checkout.js"></script>
</body>
</html>