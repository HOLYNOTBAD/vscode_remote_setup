0. 解压缩该项目到一个文件夹下，cd到这个目录
1. 保证网络通畅
2. 运行 `bash vscode_remote_setup.sh`
3. 查看输出日志，确认没有报错
4. 根据输出日志相应修改~/.bashrc
5. 运行 `bash vscode_remote_post_setup.sh`
6. 最好重新开一个终端，保证touch的临时文件生效

不成功的原因：
1. 网络不通畅
2. 没有启动ssh服务
3. 没有正确修改~/.bashrc
4. 没有重新开一个终端（需要生成一个文件来欺骗vscode使其能够通过版本检查，每次重开系统都需要这样操作）
5. VSCODE_COMMIT_ID=385651c938df8a906869babee516bffd0ddb9829 一定需要与vscode对应的版本匹配
