return {
  name = 'Launch Chrome',
  builder = function()
    print 'Chrome is starting'

    return {
      cmd = {
        'lua os.execute("nohup \\"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome\\" --user-data-dir=/tmp/chrome_test_profile --disable-features=AutoDarkMode --disable-background-networking > /dev/null 2>&1 &")',
      },
      components = {
        'on_exit_set_status',
        {
          'on_complete_dispose',
          timeout = 1,
          statuses = { 'SUCCESS' },
          require_view = {},
        },
      },
    }
  end,
}
