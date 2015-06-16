var progressSocket = io();
var currentProgress = 0;

updateProgress = function () {
  $('#progress-bar').css('width', currentProgress + '%').attr('aria-valuenow', currentProgress);
  $('#progress-span').text(currentProgress + '% Complete');
};

progressSocket.on('total', function (total) {
  $('#progress-panel').removeClass('hidden')
  $('#progress-bar').attr('aria-valuemax', total);
  currentProgress = 0;
  updateProgress();
});

progressSocket.on('issue', function () {
  currentProgress++;
  updateProgress();
});

progressSocket.on('connect', function () {
  $.ajax({
    url: '/data',
    accepts: 'application/json',
  }).done(renderIssues);
});

renderIssues = function (issues) {
  progressSocket.disconnect();
  $('#progress-panel').addClass('hidden')
  issueList = $('#issue-list')
  issues.forEach(function (issue) {
    issueList.append('<div class="panel panel-default"><div class="panel-body">' + issue.key + ' - ' + issue.summary + '</div></div>');
  });
};
