$(function () {
  var progressSocket = io();
  var requirementSprintsProgress = 0;
  var requirementSprintsTotal = 0;
  var taskSprintsProgress = 0;
  var taskSprintsTotal = 0;
  var requirementsProgress = 0;
  var requirementsTotal = 0;
  var jiraRoot;

  updateRequirementSprintsProgress = function () {
    percent = (requirementSprintsProgress / requirementSprintsTotal) * 100;
    $('#requirement-sprints-progress-bar').attr('aria-valuemax', requirementSprintsTotal);
    $('#requirement-sprints-progress-bar').css('width', percent + '%').attr('aria-valuenow', requirementSprintsProgress);
    $('#requirement-sprints-progress-span').text('Requirement Sprints ' + requirementSprintsProgress + '/' + requirementSprintsTotal);
  };

  progressSocket.on('requirementSprintsTotal', function (total) {
    requirementSprintsTotal = total;
    requirementSprintsProgress = 0;
    updateRequirementSprintsProgress();
  });

  progressSocket.on('requirementSprint', function () {
    requirementSprintsProgress++;
    updateRequirementSprintsProgress();
  });

  updateTaskSprintsProgress = function () {
    percent = (taskSprintsProgress / taskSprintsTotal) * 100;
    $('#task-sprints-progress-bar').attr('aria-valuemax', taskSprintsTotal);
    $('#task-sprints-progress-bar').css('width', percent + '%').attr('aria-valuenow', taskSprintsProgress);
    $('#task-sprints-progress-span').text('Task Sprints ' + taskSprintsProgress + '/' + taskSprintsTotal);
  };

  progressSocket.on('taskSprintsTotal', function (total) {
    taskSprintsTotal = total;
    taskSprintsProgress = 0;
    updateTaskSprintsProgress();
  });

  progressSocket.on('taskSprint', function () {
    taskSprintsProgress++;
    updateTaskSprintsProgress();
  });

  updateRequirementsProgress = function () {
    percent = (requirementsProgress / requirementsTotal) * 100;
    $('#requirements-progress-bar').attr('aria-valuemax', requirementsTotal);
    $('#requirements-progress-bar').css('width', percent + '%').attr('aria-valuenow', requirementsProgress);
    $('#requirements-progress-span').text('Requirements ' + requirementsProgress + '/' + requirementsTotal);
  };

  progressSocket.on('requirementsTotal', function (total) {
    requirementsTotal = total;
    requirementsProgress = 0;
    updateRequirementsProgress();
  });

  progressSocket.on('requirement', function () {
    requirementsProgress++;
    updateRequirementsProgress();
  });

  progressSocket.on('init', function (_jiraRoot) {
    $('#progress-panel').removeClass('hidden')
    jiraRoot = _jiraRoot;
  });

  progressSocket.on('connect', function () {
    $.ajax({
      url: '/data',
      accepts: 'application/json',
    }).done(function (data) {
      progressSocket.disconnect();
      requirementSprintsTotal = data.requirementSprints.length;
      requirementSprintsProgress = data.requirementSprints.length;
      updateRequirementSprintsProgress();
      taskSprintsTotal = data.taskSprints.length;
      taskSprintsProgress = data.taskSprints.length;
      updateTaskSprintsProgress();
      requirementsTotal = data.requirements.length;
      requirementsProgress = data.requirements.length;
      updateRequirementsProgress();
      setTimeout(function () {
        $('#progress-panel').addClass('hidden');
      }, 1000);
      renderRequirements(data.requirements);
    });
  });

  requirementHTML = function (requirement) {
    var panelColor;
    var progressValue;
    var progressMax;
    var progressPercent;
    var progressColor;
    var requirementColor
    switch (requirement.state) {
      case 'notready':
        panelColor = 'panel-danger';
        requirementColor = 'list-group-item-danger';
        break;
      case 'ready':
        panelColor = 'panel-info';
        requirementColor = 'list-group-item-info';
        break;
      case 'done':
        panelColor = 'panel-success';
        requirementColor = 'list-group-item-success';
        break;
    }
    tasks = requirement.issuelinks;
    progressMax = tasks.length;
    if (progressMax === 0) {
      progressValue = 0;
      progressPercent = 0;
      if (requirement.state === 'done') {
        progressColor = 'progress-bar-success'
        progressPercent = 100;
      } else if (requirement.state === 'notready') {
        progressColor = 'progress-bar-info'
      } else {
        progressColor = 'progress-bar-danger'
      }
    } else {
      progressValue = tasks.reduce(function (count, task) {
        return count + (task.state === 'done' ? 1 : 0);
      }, 0);
      if (progressValue === progressMax) {
        progressPercent = 100;
        if (requirement.state === 'notready') {
          progressColor = 'progress-bar-info'
        } else {
          progressColor = 'progress-bar-success'
        }
      } else {
        progressPercent = (progressValue / progressMax) * 100;
        if (requirement.state === 'done') {
          progressColor = 'progress-bar-danger'
        } else {
          progressColor = 'progress-bar-info'
        }
      }
    }
    HTML =  '<div class="panel ' + panelColor + '">';
    HTML +=   '<div class="list-group" role="tab" id="heading' + requirement.id + '">';
    HTML +=     '<a class="list-group-item ' + requirementColor + '" href="' + jiraRoot + '/browse/' + requirement.key + '" target="_blank"><span class="label label-default">' + requirement.issuetype + '</span> ' + requirement.key + ' - ' + requirement.summary + '</a>';
    HTML +=   '</div>';
    HTML +=   '<div class="panel-body">';
    if (progressMax > 0) {
      HTML +=   '<a role="button" data-toggle="collapse" href="#collapse' + requirement.id + '" aria-expanded="false" aria-controls="collapse' + requirement.id + '">';
    }
    HTML +=     '<div class="progress">';
    HTML +=       '<div class="progress-bar ' + progressColor + '" role="progressbar" aria-valuenow="' + progressValue + '" aria-valuemin="0" aria-valuemax="' + progressMax + '" style="min-width: 3em; width: ' + progressPercent + '%;">';
    HTML +=         '<span id="progress-span">' + progressValue + ' / ' + progressMax + '</span>';
    HTML +=       '</div>';
    HTML +=     '</div>';
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
