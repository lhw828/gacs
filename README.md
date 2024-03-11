# gacs
Gentoo Auto Cleanup Script
实现以下功能：
1、通过eclean-kernel删除旧内核，如果eclean-kernel未安装，则会进行安装；
2、删除/usr/portage/distfiles/*、/var/tmp/portage/*、
  /var/cache/distfiles/*三处目录内所有文件（简单粗暴）
3、粗略统计清理后释放了多少空间。
4、/usr/src/ 内的垃圾，要视情况自行手动删除
