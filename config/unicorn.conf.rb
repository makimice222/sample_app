pid "tmp/pids/unicorn.pid"
#listen 8000
listen "/var/tmp/.unicorn.sock"

# The number of worker_processes should be more than the number of CPU core at least.
# Since Unicorn handle 1 request on 1 worker , it should increase unless memory full.
worker_processes 3
timeout 20
stdout_path "log/unicorn-out.log"
stderr_path "log/unicorn-err.log"

#Master process load rails app and share it with worker_process
preload_app true

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!
  # Stop old process if exists
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end

