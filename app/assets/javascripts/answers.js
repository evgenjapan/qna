$(document).on('turbolinks:load',function () {
    $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        const target = $(this);
        target.hide();
        const answerId = target.data('answerId');
        $(`form#edit-answer-${answerId}`).show();
    });
});
