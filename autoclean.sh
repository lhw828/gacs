#!/bin/bash

# 检查是否已安装 eclean-kernel
if ! command -v eclean-kernel &> /dev/null; then
    echo "检测到尚未安装 eclean-kernel，现在开始安装..."
    emerge -av app-admin/eclean-kernel
fi

# 记录清理前根分区的总容量
before_usage=$(df -h / | tail -1 | awk '{printf "%.0f\n", $3/1024}')
echo "清理前，根分区使用量：$(df -h / | tail -1 | awk '{print $3}')"

# 开始清理旧内核源代码和相关文件
echo "正在进行旧内核源代码及关联文件的清理工作..."
eclean-kernel

# 记录清理内核文件后根分区的总容量
after_eclean_usage=$(df -h / | tail -1 | awk '{printf "%.0f\n", $3/1024}')
echo "清理旧内核源代码后，根分区使用量：$(df -h / | tail -1 | awk '{print $3}')"

# 计算清理内核源代码后释放的空间（以M为单位）
space_saved_after_eclean=$((after_eclean_usage - before_usage))
echo "清理旧内核源代码后，共释放了约 $space_saved_after_eclean M 的空间"

# 开始删除其他无用文件
echo "现在开始删除 /usr/portage/distfiles/ 下的内容..."
rm -rf /usr/portage/distfiles/*
echo "现在开始删除 /var/tmp/portage/ 下的内容..."
rm -rf /var/tmp/portage/*
echo "现在开始删除 /var/cache/distfiles/ 下的内容..."
rm -rf /var/cache/distfiles/*

# 记录删除上述文件夹后根分区的总容量
after_usage=$(df -h / | tail -1 | awk '{printf "%.0f\n", $3/1024}')
echo "删除其他文件后，根分区使用量：$(df -h / | tail -1 | awk '{print $3}')"

# 计算删除操作后进一步释放的空间（以M为单位）
additional_space_saved=$((after_eclean_usage - after_usage))
echo "删除其他文件后，共额外释放了约 $additional_space_saved M 的空间"

# 计算总共释放的空间（以M为单位）
total_space_saved=$((space_saved_after_eclean + additional_space_saved))
echo "总计释放了约 $total_space_saved M 的空间"

# 再次显示最终清理后的磁盘使用情况
echo "最终清理完毕后的根分区使用量：$(df -h / | tail -1 | awk '{print $3}')"

# 注意：这个计算方式可能不够精确，因为它考虑的是整个分区而非特定目录的使用情况
# 当目录所在分区还有其他文件时，此计算结果仅供参
# rm -rf /usr/src/*未执行。
