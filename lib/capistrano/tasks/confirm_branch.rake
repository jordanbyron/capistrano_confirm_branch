namespace :confirm_branch do
  desc 'Confirms deployment when switching deployed branches'
  task :check_deployed_branch do
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
      )
    end
  end

  desc 'Updates the file which tracks the currently deployed branch'
  task :update_current_branch do
    on release_roles(:all) do
      within shared_path do
        execute :echo, %{"#{fetch(:branch)}" > current_branch}
      end
    end
  end
end

before 'deploy', 'confirm_branch:check_deployed_branch'
after  'deploy', 'confirm_branch:update_current_branch'
