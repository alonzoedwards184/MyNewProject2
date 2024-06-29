({
    handleFileUpload: function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var fileName = uploadedFiles[0].name;
        component.set("v.fileName", fileName);
        helper.processFileUpload(component, fileName);
        
    }
})
