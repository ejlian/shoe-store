document.addEventListener('DOMContentLoaded', function() {
    const creditCardRadio = document.getElementById('credit_card');
    const codRadio = document.getElementById('cod');
    const creditCardFields = document.getElementById('credit_card_fields');
    const deliveryMethodSection = document.getElementById('delivery_method_section');
    const paymentMethodInputs = document.querySelectorAll('input[name="payment_method"]');
    const streetInput = document.querySelector('input[name="street"]');
    const barangayInput = document.querySelector('input[name="barangay"]');
    const cityInput = document.querySelector('input[name="city"]');
    const phoneInput = document.querySelector('input[name="phone"]');
    const deliveryInputs = document.querySelectorAll('input[name="delivery_method"]');
    const shippingFeeSpan = document.getElementById('shippingFee');
    const finalTotalElement = document.getElementById('finalTotal');
    const baseTotal = parseFloat(document.getElementById('baseTotal').value) || 0;

    paymentMethodInputs.forEach(input => {
        input.disabled = true;
    });

    function validateFields() {
        const isAddressFilled = streetInput.value.trim() !== '' && 
                               barangayInput.value.trim() !== '' && 
                               cityInput.value.trim() !== '';
        const isPhoneFilled = phoneInput.value.trim() !== '';
        
        const isValid = isAddressFilled && isPhoneFilled;
        paymentMethodInputs.forEach(input => { 
            input.disabled = !isValid;
        });

        if (!isValid) {
            paymentMethodInputs.forEach(input => { 
                input.checked = false;
            });
            creditCardFields.style.display = 'none';
            deliveryMethodSection.style.display = 'none';
        }
    }

    [streetInput, barangayInput, cityInput, phoneInput].forEach(input => {
        input.addEventListener('input', validateFields);
    });

    function handlePaymentMethodChange() {
        if (creditCardRadio.checked) {
            creditCardFields.style.display = 'block';
            deliveryMethodSection.style.display = 'none';
            document.querySelectorAll('input[name="delivery_method"]')
                   .forEach(radio => {radio.checked = false;});
        } else if (codRadio.checked) {
            creditCardFields.style.display = 'none';
            deliveryMethodSection.style.display = 'block';
            document.getElementById('standard').checked = true;
            document.getElementById('standard').dispatchEvent(new Event('change'));
        }
    }

    creditCardRadio.addEventListener('change', handlePaymentMethodChange);
    codRadio.addEventListener('change', handlePaymentMethodChange);

    deliveryInputs.forEach(input => {
        input.addEventListener('change', function() {
            let fee;
            switch(this.value) {
                case 'express': fee = 15.00; break;
                case 'bike': fee = 8.00; break;
                default: fee = 5.00; break;
            }
            shippingFeeSpan.textContent = `₱${fee.toFixed(2)}`;
            const finalTotal = baseTotal + fee;
            finalTotalElement.textContent = `₱${finalTotal.toFixed(2)}`;
        });
    });

    validateFields();
}); 