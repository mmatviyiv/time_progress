$(document).ready(function() {
  $('body').on('click', 'a.save', function(event) {
    event.preventDefault();
    var $form = $(this).parents('form');
    var timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    $form.find('#timezone').val(timezone);
    $form.submit();
  });

  $('body').on('click', 'a.remove', function(event) {
    if ($(this).attr('href') === '#') {
      event.preventDefault();
      event.stopImmediatePropagation();
      $(this).parents('form').remove();
    }
  });

  $('a.edit').click(function(event) {
    event.preventDefault();
    var $form = $(this).parents('form');

    $(this).hide();
    $form.find('a.save').show();
    $form.find('input, select').prop("disabled", false);
  });

  $('a.add-notifier').click(function(event) {
    event.preventDefault();
    var $container = $(this).parents('.notifier-container');
    var $list = $container.find('.list-notifiers');
    var $template = $container.find('.template form');

    $template.clone().appendTo($list);
  });
});