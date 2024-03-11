### Gentoo Auto Cleanup Script

实现以下功能：
- 通过eclean-kernel删除旧内核，如果eclean-kernel未安装，则会进行安装； 
- 删除/usr/portage/distfiles/、/var/tmp/portage/、 /var/cache/distfiles/三处目录内所有文件（简单粗暴）
- 粗略统计清理后释放了多少空间。 
- /usr/src/ 内的垃圾，要视情况自行手动删除


### Implement the following functionality:

- Use eclean-kernel to remove old kernels; if eclean-kernel is not already installed, it will be installed automatically.
- Delete all files within the directories /usr/portage/distfiles/, /var/tmp/portage/, and /var/cache/distfiles/ in a straightforward and forceful manner.
- Provide a rough estimate of the amount of space freed up after the cleanup.
- Garbage in /usr/src/ should be manually deleted based on the specific situation.
