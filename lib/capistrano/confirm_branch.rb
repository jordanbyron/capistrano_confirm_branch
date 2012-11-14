require 'capistrano'

Capistrano::Configuration.instance(:must_exist).load do
  before "deploy:update_code", "deploy:confirm_branch"
  after  "deploy",             "deploy:update_current_branch"

  namespace :deploy do
    desc 'Confirms deployment when switching deployed branches'
    task :confirm_branch do
      deployed_branch       = nil
      pending_deploy_branch = fetch(:branch)

      run %{cat #{shared_path}/current_branch} do |ch, stream, out|
        deployed_branch = out.strip
      end

      if deployed_branch != pending_deploy_branch
        Capistrano::CLI.ui.say %{
          ============ Changing deployed branches ============
          Deployed Branch:       #{deployed_branch}
          Pending Deploy Branch: #{pending_deploy_branch}
          ====================================================

        }

        abort unless Capistrano::CLI.ui.agree(
          "Do you wish to continue deploying #{pending_deploy_branch}?"
        )
      end
    end

    desc 'Updates the file which tracks the currently deployed branch'
    task :update_current_branch do
      run %{echo "#{fetch(:branch)}" > #{shared_path}/current_branch}
    end
  end
end