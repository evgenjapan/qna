$(document).on('turbolinks:load', function () {
    $('.question').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        const target = $(this);
        target.hide();
        $('#question_edit').show();
    });
});
