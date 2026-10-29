return {
  name = 'Start Dev Server',
  builder = function()
    print 'Dev server is starting'

    return {
      cmd = 'pnpm dev',
      components = { 'default', 'unique' },
    }
  end,
}
