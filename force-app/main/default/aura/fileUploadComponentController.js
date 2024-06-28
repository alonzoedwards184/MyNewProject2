// fileUploadComponentController.js
({
    handleFileUpload: function(component, event, helper) {
        var fileInput = component.find('fileUpload').getElement();
        var file = fileInput.files[0];
        var reader = new FileReader();

        reader.onloadend = function() {
            var base64Data = reader.result.match(/base64,(.*)$/)[1];
            var fileName = file.name;
            var contentType = file.type;

            // Call Apex method to upload file
            var action = component.get('c.uploadFile');
            action.setParams({
                base64Data: base64Data,
                fileName: fileName,
                contentType: contentType
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    // File uploaded successfully, handle response
                    var message = response.getReturnValue();
                    console.log(message);
                } else {
                    // Handle error or display error message
                    console.error('Error uploading file: ' + state);
                }
            });
            $A.enqueueAction(action);
        };

        reader.readAsDataURL(file);
    }
})
