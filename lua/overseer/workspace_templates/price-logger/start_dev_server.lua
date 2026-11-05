print 'Dev server is starting'

require('overseer')
  .new_task({
    cmd = 'pnpm dev',
    components = { 'default', 'unique' },
  })
  :start()
