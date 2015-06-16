$(function () {
  var progressSocket = io();
  var currentProgress = 0;
  var currentTotal = 0;
  var jiraRoot;

  updateProgress = function () {
    percent = (currentProgress / currentTotal) * 100;
    $('#progress-bar').css('width', percent + '%').attr('aria-valuenow', currentProgress);
    $('#progress-span').text(percent + '% Complete');
  };

  progressSocket.on('init', function (params) {
    currentTotal = params.total;
    jiraRoot = params.jiraRoot;
    $('#progress-panel').removeClass('hidden')
    $('#progress-bar').attr('aria-valuemax', total);
    currentProgress = 0;
    updateProgress();
  });

  progressSocket.on('requirement', function () {
    currentProgress++;
    updateProgress();
  });

  progressSocket.on('connect', function () {
    $.ajax({
      url: '/data',
      accepts: 'application/json',
    }).done(function (requirements) {
      setTimeout(function () {
        progressSocket.disconnect();
        $('#progress-panel').addClass('hidden');
      }, 1000);
      renderRequirements(requirements);
    });
  });

  requirementHTML = function (requirement) {
    var panelClass;
    var progressValue;
    var progressMax;
    var progressPercent;
    var progressColor;
    switch (requirement.state) {
      case 'notready':
        panelClass = 'panel-danger';
        requirementColor = 'list-group-item-danger';
        break;
      case 'ready':
        panelClass = 'panel-info';
        requirementColor = 'list-group-item-info';
        break;
      case 'done':
        panelClass = 'panel-success';
        requirementColor = 'list-group-item-success';
        break;
    }
    tasks = requirement.issuelinks;
    progressMax = tasks.length;
    if (progressMax === 0) {
      progressValue = 0;
      progressPercent = 100;
      if (requirement.state === 'done') {
        progressColor = 'progress-bar-success'
      } else {
        progressColor = 'progress-bar-danger'
      }
    } else {
      progressValue = tasks.reduce(function (count, task) {
        return count + (task.state === 'done' ? 1 : 0);
      }, 0);
      if (progressValue === progressMax) {
        progressPercent = 100;
        progressColor = 'progress-bar-success'
      } else {
        progressPercent = (progressValue / progressMax) * 100;
        if (requirement.state === 'done') {
          progressColor = 'progress-bar-danger'
        } else {
          progressColor = 'progress-bar-info'
        }
      }
    }
    HTML =  '<div class="panel ' + panelClass + '">';
    HTML +=   '<div class="list-group" role="tab" id="heading' + requirement.id + '">';
    HTML +=     '<a class="list-group-item ' + requirementColor + '" href="' + jiraRoot + '/browse/' + requirement.key + '" target="_blank"><span class="label label-default">' + requirement.issuetype + '</span> ' + requirement.key + ' - ' + requirement.summary + '</a>';
    HTML +=   '</div>';
    HTML +=   '<div class="panel-body">';
    if (progressMax > 0) {
      HTML +=   '<a role="button" data-toggle="collapse" href="#collapse' + requirement.id + '" aria-expanded="false" aria-controls="collapse' + requirement.id + '">';
    }
    if (requirement.state === 'notready') {
      HTML +=     'Linked issues <span class="badge">' + progressMax + '<span>';
    } else {
      HTML +=     '<div class="progress">';
      HTML +=       '<div class="progress-bar ' + progressColor + '" role="progressbar" aria-valuenow="' + progressValue + '" aria-valuemin="0" aria-valuemax="' + progressMax + '" style="width: ' + progressPercent + '%;">';
      HTML +=         '<span id="progress-span" class="sr-only">' + progressPercent + '% Complete</span>';
      HTML +=       '</div>';
      HTML +=     '</div>';
    }
    if (progressMax > 0) {
      HTML +=   '</a>';
    }
    HTML +=   '</div>';
    HTML +=   '<div id="collapse' + requirement.id + '" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading' + requirement.id + '">';
    HTML +=     '<div class="list-group">';
    tasks.forEach(function (task) {
      var taskColor = (task.state === 'done' ? 'list-group-item-success' : 'list-group-item-danger');
      HTML +=       '<a class="list-group-item ' + taskColor + '" href="' + jiraRoot + '/browse/' + task.key + '" target="_blank"><span class="label label-default">' + task.issuetype + '</span> ' + task.key + ' - ' + task.summary + '</a>';
    });
    HTML +=     '</div>';
    HTML +=   '</div>';
    HTML += '</div>';
    return HTML;
  }

  renderRequirements = function (requirements) {
    requirementList = $('#requirement-list')
    requirements.forEach(function (requirement) {
      requirementList.append(requirementHTML(requirement));
    });
  };

});
