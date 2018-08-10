namespace :confirm_branch do
  desc 'Confirms deployment when switching deployed branches'
  task :check_deployed_branch do
    return unless fetch(:confirm_branch_before_deploy, true)

    ui                    = HighLine.new
    deployed_branch       = nil
    pending_deploy_branch = fetch(:branch)
    current_branch_path   = shared_path + "current_branch"

    on release_roles(:all) do
      within shared_path do
        deployed_branch = capture(
          %{touch #{current_branch_path} && cat #{current_branch_path}}
        ).strip
      end
    end

    if deployed_branch != pending_deploy_branch
      deployed_branch = "<UNKNOWN>" if deployed_branch == ""

      ui.say %{
        ============ Changing deployed branches ============
        Deployed Branch:       #{deployed_branch}
        Pending Deploy Branch: #{pending_deploy_branch}
        ====================================================

      }

      abort unless ui.agree(
        "Do you wish to continue deploying #{pending_deploy_branch}?"
      )  {|a| a.default = 'yes' }
    end
  end

  desc 'Confirms there are no pending commits to be pushed'
  task :check_unpushed_commits do
    if fetch(:scm).to_s == 'git' &&
      fetch(:check_unpushed_commits_before_deploy, true)
      pending_commits = `git status`

      unless pending_commits[/Your branch is up.to.date/]
        pending_commits = /(Your branch is ahead of '\S*' by \d commits?)/.
          match(pending_commits).captures.first

        ui = HighLine.new

        ui.say %{
          ============ WARNING: Unpushed Commits Present ============

          #{pending_commits}

          ===========================================================

        }

        abort unless ui.agree(
          "Do you wish to continue deploying?"
        ) {|a| a.default = 'yes' }
      end
    end
  end

  desc 'Updates the file which tracks the currently deployed branch'
  task :update_current_branch do
    return unless fetch(:confirm_branch_before_deploy, true)

    on release_roles(:all) do
      within shared_path do
        execute :echo, %{"#{fetch(:branch)}" > current_branch}
      end
    end
  end
end

before 'deploy', 'confirm_branch:check_unpushed_commits'

before 'deploy', 'confirm_branch:check_deployed_branch'
after  'deploy', 'confirm_branch:update_current_branch'
