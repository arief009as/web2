﻿function getJqueryObject(obj) {
    if (obj === undefined) return undefined;
    return (isString(obj))
        ? $('#' + obj)
        : (obj.jquery ? obj : $(obj));
}
function isJqueryObject(obj) {
    return obj !== undefined && getJqueryObject(obj).length > 0;
}
function isString(obj) {
    return typeof obj === 'string';
}


function clearValidation(el) {
    var $form = isJqueryObject(el) ? el : getJqueryObject(el);
    $form.find("span.text-danger").text("");
    $form.find(" input.form-control").removeClass("is-invalid");
    $form.find("span.invalid[data-validation-for]").text("");
    $form.find(".is-invalid").removeClass("is-invalid");
    $form.find(".is-valid").removeClass("is-valid");
    $form.find(".fv-plugins-message-container").html("");
}

function ShowErrorMessage($form, result) {
    clearValidation($form);
    for (let i = 0; i < result.length; i++) {
        let PropertyName = result[i].PropertyName;
        let ErrorMessage = result[i].ErrorMessage;
        let $el = $('[name="' + PropertyName + '"]', $form);
        $el.parent().find('span.text-danger').append(ErrorMessage);
        if ($el.parent().find('span.text-danger').length == 0) {
            $el.parent().parent().find('span.text-danger').append(ErrorMessage);
        }
    }
}

function ShowClaimGridErrorMessage($form, result) {
    clearValidation($form);

    var htmlString = "<ul style='color: red;'>";
    $.each(result, function (index, item) {
        htmlString += "<li>" + item.ErrorMessage + "</li>";

        let $el = $('input[name="' + item.PropertyName + '"]', $form);
        $el.parent().find('input[type=text]').addClass('input-error');
    });

    htmlString += "</ul>";
    $(".error-div").html(htmlString);
    $(".error-div").show();
}

function ClearClaimGridErrorMessage($form, result) {
    clearValidation($form);

    $(".claimcodetable input[type=text]").each(function (index, item) {
        $(item).removeClass("input-error");
    });

    $(".error-div").html("");
    $(".error-div").hide();
}

function ShowAPIErrorMessage($form, result) {
    clearValidation($form);
    for (let i = 0; i < result.length; i++) {
        let PropertyName = result[i].propertyName;
        let ErrorMessage = result[i].errorMessage;
        let $el = $('[name="' + PropertyName + '"]', $form);
        $el.parent().find('span.text-danger').append(ErrorMessage);
        if ($el.parent().find('span.text-danger').length == 0) {
            $el.parent().parent().find('span.text-danger').append(ErrorMessage);
        }
    }
}

String.prototype.format = function () {
    var args = arguments;
    return this.replace(/{([0-9]+)}/g, function (match, index) {
        return typeof args[index] == 'undefined' ? match : args[index];
    });
};