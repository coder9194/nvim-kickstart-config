local NODE_MODES = { 'sit', 'uat' }

print 'Android Dev App is starting'

vim.ui.select(NODE_MODES, { prompt = 'Select NODE_MODE' }, function(selected_node_mode)
  if not selected_node_mode then
    return
  end

  require('overseer')
    .new_task({
      cmd = 'source ~/.zshrc && cd ./app && sdk use java 21.0.11-sapmchn && NODE_MODE='
        .. selected_node_mode
        .. ' npx cap run android --forwardPorts 4200:4200 --host localhost --port 4200 -l -- --mode $NODE_MODE',
    })
    :start()
end)
