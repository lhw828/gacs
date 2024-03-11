#!/bin/bash

# 检查是否已安装 eclean-kernel
if ! command -v eclean-kernel &> /dev/null
then
    echo "eclean-kernel is not installed. Installing now..."
    emerge -av app-admin/eclean-kernel
fi

# 记录删除前分区的总用量（以M为单位）
before_usage=$(df -h / | tail -1 | awk '{printf "%.0f\n", $3/1024}')

# 清理旧内核源代码
eclean-kernel -d src

# 记录清理内核源代码后分区的总用量（以M为单位）
after_eclean_usage=$(df -h / | tail -1 | awk '{printf "%.0f\n", $3/1024}')

# 计算清理内核源代码后释放的空间（以M为单位）
space_saved_after_eclean=$((after_eclean_usage - before_usage))
echo "Space saved after cleaning kernel sources: $space_saved_after_eclean M"

# 执行删除操作
rm -rf /usr/portage/distfiles/*
rm -rf /var/tmp/portage/*
rm -rf /var/cache/distfiles/*

# 记录删除上述文件夹后分区的总用量（以M为单位）
after_usage=$(df -h / | tail -1 | awk '{printf "%.0f\n", $3/1024}')

# 计算删除操作后进一步释放的空间（以M为单位）
additional_space_saved=$((after_eclean_usage - after_usage))
echo "Space saved after deleting other files: $additional_space_saved M"

# 合并两次释放的空间（以M为单位）
total_space_saved=$((space_saved_after_eclean + additional_space_saved))
echo "Total approximate space saved: $total_space_saved M"

# 显示清理前后的磁盘使用情况（保留原始单位，便于阅读）
echo "Before deletion, disk usage: $(df -h / | tail -1 | awk '{print $3}')"
echo "After cleaning kernel sources, disk usage: $(df -h / | tail -1 | awk '{print $3}')"
echo "After deleting other files, disk usage: $(df -h / | tail -1 | awk '{print $3}')"

# 注意：这个计算方式可能不够精确，因为它考虑的是整个分区而非特定目录的使用情况
# 当目录所在分区还有其他文件时，此计算结果仅供参
# rm -rf /usr/src/*未执行。
