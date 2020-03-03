/*https://codeseven.github.io/toastr/demo.html*/

toastr.options = {
    "positionClass": "toast-bottom-right",
    "showMethod": "slideDown",
    "hideMethod": "slideUp"
}

showToaster = function (message, type) {
    toastr.remove();
    if (type.toLowerCase() == "error")
        toastr.error(message);
    if (type.toLowerCase() == "warning")
        toastr.warning(message);
    if (type.toLowerCase() == "info")
        toastr.info(message);
    if (type.toLowerCase() == "success")
        toastr.success(message);
};