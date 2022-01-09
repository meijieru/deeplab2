settings({
  logfile = "/tmp/lsyncd/deeplab2.log",
  statusFile = "/tmp/lsyncd/deeplab2.status",
  -- statusInterval = 5,
  inotifyMode = "Modify",
  maxProcesses = 1,
  nodaemon = true,
  -- maxDelays      = 5,
})

sync({
  default.rsyncssh,
  source = "/home/jmei/workspace/machine_learning/segmentation/deeplab2/deeplab2",
  host = "ccvl9",
  targetdir = "/home/meijieru/workspace/machine_learning/segmentation/deeplab2/deeplab2",
  delay = 0,
  exclude = { "__pycache__", "checkpoints", "*.log", "*.tar", "*.lua", "pretrained", ".git" },
  -- init           = false,
  delete = "true",
  rsync = {
    binary = "/usr/bin/rsync",
    archive = true,
    compress = true,
    verbose = true,
    bwlimit = 2000,
  },
  ssh = {
    identityFile = "~/.ssh/id_rsa",
  },
})
