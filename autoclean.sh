#!/bin/bash

# 定义函数用于转换字节到MB或GB
function convert_size {
    local size=$1
    local gb=$(awk "BEGIN {printf \"%.1f\", ($size / 1024 / 1024 / 1024)}")

    if (( $(echo "$gb >= 1" | bc -l) )); then
        echo "${gb}GB"
    else
        local mb=$(awk "BEGIN {printf \"%d\", ($size / 1024 / 1024)}")
        echo "${mb}MB"
    fi
}

# 检查是否已安装 eclean-kernel
if ! command -v eclean-kernel &> /dev/null; then
    echo "检测到尚未安装 eclean-kernel，现在开始安装..."
    emerge -av app-admin/eclean-kernel
fi

# 清理前记录根分区的总容量
before_usage=$(df -B1 / | tail -1 | awk '{print $3}')

echo "清理前，根分区使用量：$(convert_size $before_usage)"

# 开始清理旧内核源代码和相关文件
echo "正在进行旧内核源代码及关联文件的清理工作..."
eclean-kernel

# 清理内核源码后记录根分区的总容量
after_eclean_usage=$(df -B1 / | tail -1 | awk '{print $3}')

# 计算清理内核源码后释放的空间（以B为单位）
space_saved_after_eclean=$((before_usage - after_eclean_usage))

echo "清理旧内核源代码后，根分区使用量：$(convert_size $after_eclean_usage)"
echo "清理旧内核源代码后，共释放了 $(convert_size $space_saved_after_eclean)"

# 开始删除其他无用文件
echo "现在开始删除 /usr/portage/distfiles/ 下的内容..."
rm -rf /usr/portage/distfiles/*
echo "现在开始删除 /var/tmp/portage/ 下的内容..."
rm -rf /var/tmp/portage/*
echo "现在开始删除 /var/cache/distfiles/ 下的内容..."
rm -rf /var/cache/distfiles/*

# 删除其他文件后记录根分区的总容量
after_usage=$(df -B1 / | tail -1 | awk '{print $3}')

# 计算删除操作后进一步释放的空间（以B为单位）
additional_space_saved=$((after_eclean_usage - after_usage))

echo "删除其他文件后，根分区使用量：$(convert_size $after_usage)"
echo "删除其他文件后，共额外释放了 $(convert_size $additional_space_saved)"

# 计算总共释放的空间（以B为单位）
total_space_saved=$((before_usage - after_usage))

echo "总计释放了 $(convert_size $total_space_saved) 的空间"

# 显示最终清理后的磁盘使用情况
echo "最终清理完毕后的根分区使用量：$(convert_size $after_usage)"
