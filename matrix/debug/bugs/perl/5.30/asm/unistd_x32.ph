require '_h2ph_pre.ph';

no warnings qw(redefine misc);

unless(defined(&_ASM_X86_UNISTD_X32_H)) {
    eval 'sub _ASM_X86_UNISTD_X32_H () {1;}' unless defined(&_ASM_X86_UNISTD_X32_H);
    eval 'sub __NR_read () {( &__X32_SYSCALL_BIT + 0);}' unless defined(&__NR_read);
    eval 'sub __NR_write () {( &__X32_SYSCALL_BIT + 1);}' unless defined(&__NR_write);
    eval 'sub __NR_open () {( &__X32_SYSCALL_BIT + 2);}' unless defined(&__NR_open);
    eval 'sub __NR_close () {( &__X32_SYSCALL_BIT + 3);}' unless defined(&__NR_close);
    eval 'sub __NR_stat () {( &__X32_SYSCALL_BIT + 4);}' unless defined(&__NR_stat);
    eval 'sub __NR_fstat () {( &__X32_SYSCALL_BIT + 5);}' unless defined(&__NR_fstat);
    eval 'sub __NR_lstat () {( &__X32_SYSCALL_BIT + 6);}' unless defined(&__NR_lstat);
    eval 'sub __NR_poll () {( &__X32_SYSCALL_BIT + 7);}' unless defined(&__NR_poll);
    eval 'sub __NR_lseek () {( &__X32_SYSCALL_BIT + 8);}' unless defined(&__NR_lseek);
    eval 'sub __NR_mmap () {( &__X32_SYSCALL_BIT + 9);}' unless defined(&__NR_mmap);
    eval 'sub __NR_mprotect () {( &__X32_SYSCALL_BIT + 10);}' unless defined(&__NR_mprotect);
    eval 'sub __NR_munmap () {( &__X32_SYSCALL_BIT + 11);}' unless defined(&__NR_munmap);
    eval 'sub __NR_brk () {( &__X32_SYSCALL_BIT + 12);}' unless defined(&__NR_brk);
    eval 'sub __NR_rt_sigprocmask () {( &__X32_SYSCALL_BIT + 14);}' unless defined(&__NR_rt_sigprocmask);
    eval 'sub __NR_pread64 () {( &__X32_SYSCALL_BIT + 17);}' unless defined(&__NR_pread64);
    eval 'sub __NR_pwrite64 () {( &__X32_SYSCALL_BIT + 18);}' unless defined(&__NR_pwrite64);
    eval 'sub __NR_access () {( &__X32_SYSCALL_BIT + 21);}' unless defined(&__NR_access);
    eval 'sub __NR_pipe () {( &__X32_SYSCALL_BIT + 22);}' unless defined(&__NR_pipe);
    eval 'sub __NR_select () {( &__X32_SYSCALL_BIT + 23);}' unless defined(&__NR_select);
    eval 'sub __NR_sched_yield () {( &__X32_SYSCALL_BIT + 24);}' unless defined(&__NR_sched_yield);
    eval 'sub __NR_mremap () {( &__X32_SYSCALL_BIT + 25);}' unless defined(&__NR_mremap);
    eval 'sub __NR_msync () {( &__X32_SYSCALL_BIT + 26);}' unless defined(&__NR_msync);
    eval 'sub __NR_mincore () {( &__X32_SYSCALL_BIT + 27);}' unless defined(&__NR_mincore);
    eval 'sub __NR_madvise () {( &__X32_SYSCALL_BIT + 28);}' unless defined(&__NR_madvise);
    eval 'sub __NR_shmget () {( &__X32_SYSCALL_BIT + 29);}' unless defined(&__NR_shmget);
    eval 'sub __NR_shmat () {( &__X32_SYSCALL_BIT + 30);}' unless defined(&__NR_shmat);
    eval 'sub __NR_shmctl () {( &__X32_SYSCALL_BIT + 31);}' unless defined(&__NR_shmctl);
    eval 'sub __NR_dup () {( &__X32_SYSCALL_BIT + 32);}' unless defined(&__NR_dup);
    eval 'sub __NR_dup2 () {( &__X32_SYSCALL_BIT + 33);}' unless defined(&__NR_dup2);
    eval 'sub __NR_pause () {( &__X32_SYSCALL_BIT + 34);}' unless defined(&__NR_pause);
    eval 'sub __NR_nanosleep () {( &__X32_SYSCALL_BIT + 35);}' unless defined(&__NR_nanosleep);
    eval 'sub __NR_getitimer () {( &__X32_SYSCALL_BIT + 36);}' unless defined(&__NR_getitimer);
    eval 'sub __NR_alarm () {( &__X32_SYSCALL_BIT + 37);}' unless defined(&__NR_alarm);
    eval 'sub __NR_setitimer () {( &__X32_SYSCALL_BIT + 38);}' unless defined(&__NR_setitimer);
    eval 'sub __NR_getpid () {( &__X32_SYSCALL_BIT + 39);}' unless defined(&__NR_getpid);
    eval 'sub __NR_sendfile () {( &__X32_SYSCALL_BIT + 40);}' unless defined(&__NR_sendfile);
    eval 'sub __NR_socket () {( &__X32_SYSCALL_BIT + 41);}' unless defined(&__NR_socket);
    eval 'sub __NR_connect () {( &__X32_SYSCALL_BIT + 42);}' unless defined(&__NR_connect);
    eval 'sub __NR_accept () {( &__X32_SYSCALL_BIT + 43);}' unless defined(&__NR_accept);
    eval 'sub __NR_sendto () {( &__X32_SYSCALL_BIT + 44);}' unless defined(&__NR_sendto);
    eval 'sub __NR_shutdown () {( &__X32_SYSCALL_BIT + 48);}' unless defined(&__NR_shutdown);
    eval 'sub __NR_bind () {( &__X32_SYSCALL_BIT + 49);}' unless defined(&__NR_bind);
    eval 'sub __NR_listen () {( &__X32_SYSCALL_BIT + 50);}' unless defined(&__NR_listen);
    eval 'sub __NR_getsockname () {( &__X32_SYSCALL_BIT + 51);}' unless defined(&__NR_getsockname);
    eval 'sub __NR_getpeername () {( &__X32_SYSCALL_BIT + 52);}' unless defined(&__NR_getpeername);
    eval 'sub __NR_socketpair () {( &__X32_SYSCALL_BIT + 53);}' unless defined(&__NR_socketpair);
    eval 'sub __NR_clone () {( &__X32_SYSCALL_BIT + 56);}' unless defined(&__NR_clone);
    eval 'sub __NR_fork () {( &__X32_SYSCALL_BIT + 57);}' unless defined(&__NR_fork);
    eval 'sub __NR_vfork () {( &__X32_SYSCALL_BIT + 58);}' unless defined(&__NR_vfork);
    eval 'sub __NR_exit () {( &__X32_SYSCALL_BIT + 60);}' unless defined(&__NR_exit);
    eval 'sub __NR_wait4 () {( &__X32_SYSCALL_BIT + 61);}' unless defined(&__NR_wait4);
    eval 'sub __NR_kill () {( &__X32_SYSCALL_BIT + 62);}' unless defined(&__NR_kill);
    eval 'sub __NR_uname () {( &__X32_SYSCALL_BIT + 63);}' unless defined(&__NR_uname);
    eval 'sub __NR_semget () {( &__X32_SYSCALL_BIT + 64);}' unless defined(&__NR_semget);
    eval 'sub __NR_semop () {( &__X32_SYSCALL_BIT + 65);}' unless defined(&__NR_semop);
    eval 'sub __NR_semctl () {( &__X32_SYSCALL_BIT + 66);}' unless defined(&__NR_semctl);
    eval 'sub __NR_shmdt () {( &__X32_SYSCALL_BIT + 67);}' unless defined(&__NR_shmdt);
    eval 'sub __NR_msgget () {( &__X32_SYSCALL_BIT + 68);}' unless defined(&__NR_msgget);
    eval 'sub __NR_msgsnd () {( &__X32_SYSCALL_BIT + 69);}' unless defined(&__NR_msgsnd);
    eval 'sub __NR_msgrcv () {( &__X32_SYSCALL_BIT + 70);}' unless defined(&__NR_msgrcv);
    eval 'sub __NR_msgctl () {( &__X32_SYSCALL_BIT + 71);}' unless defined(&__NR_msgctl);
    eval 'sub __NR_fcntl () {( &__X32_SYSCALL_BIT + 72);}' unless defined(&__NR_fcntl);
    eval 'sub __NR_flock () {( &__X32_SYSCALL_BIT + 73);}' unless defined(&__NR_flock);
    eval 'sub __NR_fsync () {( &__X32_SYSCALL_BIT + 74);}' unless defined(&__NR_fsync);
    eval 'sub __NR_fdatasync () {( &__X32_SYSCALL_BIT + 75);}' unless defined(&__NR_fdatasync);
    eval 'sub __NR_truncate () {( &__X32_SYSCALL_BIT + 76);}' unless defined(&__NR_truncate);
    eval 'sub __NR_ftruncate () {( &__X32_SYSCALL_BIT + 77);}' unless defined(&__NR_ftruncate);
    eval 'sub __NR_getdents () {( &__X32_SYSCALL_BIT + 78);}' unless defined(&__NR_getdents);
    eval 'sub __NR_getcwd () {( &__X32_SYSCALL_BIT + 79);}' unless defined(&__NR_getcwd);
    eval 'sub __NR_chdir () {( &__X32_SYSCALL_BIT + 80);}' unless defined(&__NR_chdir);
    eval 'sub __NR_fchdir () {( &__X32_SYSCALL_BIT + 81);}' unless defined(&__NR_fchdir);
    eval 'sub __NR_rename () {( &__X32_SYSCALL_BIT + 82);}' unless defined(&__NR_rename);
    eval 'sub __NR_mkdir () {( &__X32_SYSCALL_BIT + 83);}' unless defined(&__NR_mkdir);
    eval 'sub __NR_rmdir () {( &__X32_SYSCALL_BIT + 84);}' unless defined(&__NR_rmdir);
    eval 'sub __NR_creat () {( &__X32_SYSCALL_BIT + 85);}' unless defined(&__NR_creat);
    eval 'sub __NR_link () {( &__X32_SYSCALL_BIT + 86);}' unless defined(&__NR_link);
    eval 'sub __NR_unlink () {( &__X32_SYSCALL_BIT + 87);}' unless defined(&__NR_unlink);
    eval 'sub __NR_symlink () {( &__X32_SYSCALL_BIT + 88);}' unless defined(&__NR_symlink);
    eval 'sub __NR_readlink () {( &__X32_SYSCALL_BIT + 89);}' unless defined(&__NR_readlink);
    eval 'sub __NR_chmod () {( &__X32_SYSCALL_BIT + 90);}' unless defined(&__NR_chmod);
    eval 'sub __NR_fchmod () {( &__X32_SYSCALL_BIT + 91);}' unless defined(&__NR_fchmod);
    eval 'sub __NR_chown () {( &__X32_SYSCALL_BIT + 92);}' unless defined(&__NR_chown);
    eval 'sub __NR_fchown () {( &__X32_SYSCALL_BIT + 93);}' unless defined(&__NR_fchown);
    eval 'sub __NR_lchown () {( &__X32_SYSCALL_BIT + 94);}' unless defined(&__NR_lchown);
    eval 'sub __NR_umask () {( &__X32_SYSCALL_BIT + 95);}' unless defined(&__NR_umask);
    eval 'sub __NR_gettimeofday () {( &__X32_SYSCALL_BIT + 96);}' unless defined(&__NR_gettimeofday);
    eval 'sub __NR_getrlimit () {( &__X32_SYSCALL_BIT + 97);}' unless defined(&__NR_getrlimit);
    eval 'sub __NR_getrusage () {( &__X32_SYSCALL_BIT + 98);}' unless defined(&__NR_getrusage);
    eval 'sub __NR_sysinfo () {( &__X32_SYSCALL_BIT + 99);}' unless defined(&__NR_sysinfo);
    eval 'sub __NR_times () {( &__X32_SYSCALL_BIT + 100);}' unless defined(&__NR_times);
    eval 'sub __NR_getuid () {( &__X32_SYSCALL_BIT + 102);}' unless defined(&__NR_getuid);
    eval 'sub __NR_syslog () {( &__X32_SYSCALL_BIT + 103);}' unless defined(&__NR_syslog);
    eval 'sub __NR_getgid () {( &__X32_SYSCALL_BIT + 104);}' unless defined(&__NR_getgid);
    eval 'sub __NR_setuid () {( &__X32_SYSCALL_BIT + 105);}' unless defined(&__NR_setuid);
    eval 'sub __NR_setgid () {( &__X32_SYSCALL_BIT + 106);}' unless defined(&__NR_setgid);
    eval 'sub __NR_geteuid () {( &__X32_SYSCALL_BIT + 107);}' unless defined(&__NR_geteuid);
    eval 'sub __NR_getegid () {( &__X32_SYSCALL_BIT + 108);}' unless defined(&__NR_getegid);
    eval 'sub __NR_setpgid () {( &__X32_SYSCALL_BIT + 109);}' unless defined(&__NR_setpgid);
    eval 'sub __NR_getppid () {( &__X32_SYSCALL_BIT + 110);}' unless defined(&__NR_getppid);
    eval 'sub __NR_getpgrp () {( &__X32_SYSCALL_BIT + 111);}' unless defined(&__NR_getpgrp);
    eval 'sub __NR_setsid () {( &__X32_SYSCALL_BIT + 112);}' unless defined(&__NR_setsid);
    eval 'sub __NR_setreuid () {( &__X32_SYSCALL_BIT + 113);}' unless defined(&__NR_setreuid);
    eval 'sub __NR_setregid () {( &__X32_SYSCALL_BIT + 114);}' unless defined(&__NR_setregid);
    eval 'sub __NR_getgroups () {( &__X32_SYSCALL_BIT + 115);}' unless defined(&__NR_getgroups);
    eval 'sub __NR_setgroups () {( &__X32_SYSCALL_BIT + 116);}' unless defined(&__NR_setgroups);
    eval 'sub __NR_setresuid () {( &__X32_SYSCALL_BIT + 117);}' unless defined(&__NR_setresuid);
    eval 'sub __NR_getresuid () {( &__X32_SYSCALL_BIT + 118);}' unless defined(&__NR_getresuid);
    eval 'sub __NR_setresgid () {( &__X32_SYSCALL_BIT + 119);}' unless defined(&__NR_setresgid);
    eval 'sub __NR_getresgid () {( &__X32_SYSCALL_BIT + 120);}' unless defined(&__NR_getresgid);
    eval 'sub __NR_getpgid () {( &__X32_SYSCALL_BIT + 121);}' unless defined(&__NR_getpgid);
    eval 'sub __NR_setfsuid () {( &__X32_SYSCALL_BIT + 122);}' unless defined(&__NR_setfsuid);
    eval 'sub __NR_setfsgid () {( &__X32_SYSCALL_BIT + 123);}' unless defined(&__NR_setfsgid);
    eval 'sub __NR_getsid () {( &__X32_SYSCALL_BIT + 124);}' unless defined(&__NR_getsid);
    eval 'sub __NR_capget () {( &__X32_SYSCALL_BIT + 125);}' unless defined(&__NR_capget);
    eval 'sub __NR_capset () {( &__X32_SYSCALL_BIT + 126);}' unless defined(&__NR_capset);
    eval 'sub __NR_rt_sigsuspend () {( &__X32_SYSCALL_BIT + 130);}' unless defined(&__NR_rt_sigsuspend);
    eval 'sub __NR_utime () {( &__X32_SYSCALL_BIT + 132);}' unless defined(&__NR_utime);
    eval 'sub __NR_mknod () {( &__X32_SYSCALL_BIT + 133);}' unless defined(&__NR_mknod);
    eval 'sub __NR_personality () {( &__X32_SYSCALL_BIT + 135);}' unless defined(&__NR_personality);
    eval 'sub __NR_ustat () {( &__X32_SYSCALL_BIT + 136);}' unless defined(&__NR_ustat);
    eval 'sub __NR_statfs () {( &__X32_SYSCALL_BIT + 137);}' unless defined(&__NR_statfs);
    eval 'sub __NR_fstatfs () {( &__X32_SYSCALL_BIT + 138);}' unless defined(&__NR_fstatfs);
    eval 'sub __NR_sysfs () {( &__X32_SYSCALL_BIT + 139);}' unless defined(&__NR_sysfs);
    eval 'sub __NR_getpriority () {( &__X32_SYSCALL_BIT + 140);}' unless defined(&__NR_getpriority);
    eval 'sub __NR_setpriority () {( &__X32_SYSCALL_BIT + 141);}' unless defined(&__NR_setpriority);
    eval 'sub __NR_sched_setparam () {( &__X32_SYSCALL_BIT + 142);}' unless defined(&__NR_sched_setparam);
    eval 'sub __NR_sched_getparam () {( &__X32_SYSCALL_BIT + 143);}' unless defined(&__NR_sched_getparam);
    eval 'sub __NR_sched_setscheduler () {( &__X32_SYSCALL_BIT + 144);}' unless defined(&__NR_sched_setscheduler);
    eval 'sub __NR_sched_getscheduler () {( &__X32_SYSCALL_BIT + 145);}' unless defined(&__NR_sched_getscheduler);
    eval 'sub __NR_sched_get_priority_max () {( &__X32_SYSCALL_BIT + 146);}' unless defined(&__NR_sched_get_priority_max);
    eval 'sub __NR_sched_get_priority_min () {( &__X32_SYSCALL_BIT + 147);}' unless defined(&__NR_sched_get_priority_min);
    eval 'sub __NR_sched_rr_get_interval () {( &__X32_SYSCALL_BIT + 148);}' unless defined(&__NR_sched_rr_get_interval);
    eval 'sub __NR_mlock () {( &__X32_SYSCALL_BIT + 149);}' unless defined(&__NR_mlock);
    eval 'sub __NR_munlock () {( &__X32_SYSCALL_BIT + 150);}' unless defined(&__NR_munlock);
    eval 'sub __NR_mlockall () {( &__X32_SYSCALL_BIT + 151);}' unless defined(&__NR_mlockall);
    eval 'sub __NR_munlockall () {( &__X32_SYSCALL_BIT + 152);}' unless defined(&__NR_munlockall);
    eval 'sub __NR_vhangup () {( &__X32_SYSCALL_BIT + 153);}' unless defined(&__NR_vhangup);
    eval 'sub __NR_modify_ldt () {( &__X32_SYSCALL_BIT + 154);}' unless defined(&__NR_modify_ldt);
    eval 'sub __NR_pivot_root () {( &__X32_SYSCALL_BIT + 155);}' unless defined(&__NR_pivot_root);
    eval 'sub __NR_prctl () {( &__X32_SYSCALL_BIT + 157);}' unless defined(&__NR_prctl);
    eval 'sub __NR_arch_prctl () {( &__X32_SYSCALL_BIT + 158);}' unless defined(&__NR_arch_prctl);
    eval 'sub __NR_adjtimex () {( &__X32_SYSCALL_BIT + 159);}' unless defined(&__NR_adjtimex);
    eval 'sub __NR_setrlimit () {( &__X32_SYSCALL_BIT + 160);}' unless defined(&__NR_setrlimit);
    eval 'sub __NR_chroot () {( &__X32_SYSCALL_BIT + 161);}' unless defined(&__NR_chroot);
    eval 'sub __NR_sync () {( &__X32_SYSCALL_BIT + 162);}' unless defined(&__NR_sync);
    eval 'sub __NR_acct () {( &__X32_SYSCALL_BIT + 163);}' unless defined(&__NR_acct);
    eval 'sub __NR_settimeofday () {( &__X32_SYSCALL_BIT + 164);}' unless defined(&__NR_settimeofday);
    eval 'sub __NR_mount () {( &__X32_SYSCALL_BIT + 165);}' unless defined(&__NR_mount);
    eval 'sub __NR_umount2 () {( &__X32_SYSCALL_BIT + 166);}' unless defined(&__NR_umount2);
    eval 'sub __NR_swapon () {( &__X32_SYSCALL_BIT + 167);}' unless defined(&__NR_swapon);
    eval 'sub __NR_swapoff () {( &__X32_SYSCALL_BIT + 168);}' unless defined(&__NR_swapoff);
    eval 'sub __NR_reboot () {( &__X32_SYSCALL_BIT + 169);}' unless defined(&__NR_reboot);
    eval 'sub __NR_sethostname () {( &__X32_SYSCALL_BIT + 170);}' unless defined(&__NR_sethostname);
    eval 'sub __NR_setdomainname () {( &__X32_SYSCALL_BIT + 171);}' unless defined(&__NR_setdomainname);
    eval 'sub __NR_iopl () {( &__X32_SYSCALL_BIT + 172);}' unless defined(&__NR_iopl);
    eval 'sub __NR_ioperm () {( &__X32_SYSCALL_BIT + 173);}' unless defined(&__NR_ioperm);
    eval 'sub __NR_init_module () {( &__X32_SYSCALL_BIT + 175);}' unless defined(&__NR_init_module);
    eval 'sub __NR_delete_module () {( &__X32_SYSCALL_BIT + 176);}' unless defined(&__NR_delete_module);
    eval 'sub __NR_quotactl () {( &__X32_SYSCALL_BIT + 179);}' unless defined(&__NR_quotactl);
    eval 'sub __NR_getpmsg () {( &__X32_SYSCALL_BIT + 181);}' unless defined(&__NR_getpmsg);
    eval 'sub __NR_putpmsg () {( &__X32_SYSCALL_BIT + 182);}' unless defined(&__NR_putpmsg);
    eval 'sub __NR_afs_syscall () {( &__X32_SYSCALL_BIT + 183);}' unless defined(&__NR_afs_syscall);
    eval 'sub __NR_tuxcall () {( &__X32_SYSCALL_BIT + 184);}' unless defined(&__NR_tuxcall);
    eval 'sub __NR_security () {( &__X32_SYSCALL_BIT + 185);}' unless defined(&__NR_security);
    eval 'sub __NR_gettid () {( &__X32_SYSCALL_BIT + 186);}' unless defined(&__NR_gettid);
    eval 'sub __NR_readahead () {( &__X32_SYSCALL_BIT + 187);}' unless defined(&__NR_readahead);
    eval 'sub __NR_setxattr () {( &__X32_SYSCALL_BIT + 188);}' unless defined(&__NR_setxattr);
    eval 'sub __NR_lsetxattr () {( &__X32_SYSCALL_BIT + 189);}' unless defined(&__NR_lsetxattr);
    eval 'sub __NR_fsetxattr () {( &__X32_SYSCALL_BIT + 190);}' unless defined(&__NR_fsetxattr);
    eval 'sub __NR_getxattr () {( &__X32_SYSCALL_BIT + 191);}' unless defined(&__NR_getxattr);
    eval 'sub __NR_lgetxattr () {( &__X32_SYSCALL_BIT + 192);}' unless defined(&__NR_lgetxattr);
    eval 'sub __NR_fgetxattr () {( &__X32_SYSCALL_BIT + 193);}' unless defined(&__NR_fgetxattr);
    eval 'sub __NR_listxattr () {( &__X32_SYSCALL_BIT + 194);}' unless defined(&__NR_listxattr);
    eval 'sub __NR_llistxattr () {( &__X32_SYSCALL_BIT + 195);}' unless defined(&__NR_llistxattr);
    eval 'sub __NR_flistxattr () {( &__X32_SYSCALL_BIT + 196);}' unless defined(&__NR_flistxattr);
    eval 'sub __NR_removexattr () {( &__X32_SYSCALL_BIT + 197);}' unless defined(&__NR_removexattr);
    eval 'sub __NR_lremovexattr () {( &__X32_SYSCALL_BIT + 198);}' unless defined(&__NR_lremovexattr);
    eval 'sub __NR_fremovexattr () {( &__X32_SYSCALL_BIT + 199);}' unless defined(&__NR_fremovexattr);
    eval 'sub __NR_tkill () {( &__X32_SYSCALL_BIT + 200);}' unless defined(&__NR_tkill);
    eval 'sub __NR_time () {( &__X32_SYSCALL_BIT + 201);}' unless defined(&__NR_time);
    eval 'sub __NR_futex () {( &__X32_SYSCALL_BIT + 202);}' unless defined(&__NR_futex);
    eval 'sub __NR_sched_setaffinity () {( &__X32_SYSCALL_BIT + 203);}' unless defined(&__NR_sched_setaffinity);
    eval 'sub __NR_sched_getaffinity () {( &__X32_SYSCALL_BIT + 204);}' unless defined(&__NR_sched_getaffinity);
    eval 'sub __NR_io_destroy () {( &__X32_SYSCALL_BIT + 207);}' unless defined(&__NR_io_destroy);
    eval 'sub __NR_io_getevents () {( &__X32_SYSCALL_BIT + 208);}' unless defined(&__NR_io_getevents);
    eval 'sub __NR_io_cured () {( &__X32_SYSCALL_BIT + 210);}' unless defined(&__NR_io_cured);
    eval 'sub __NR_lookup_dcookie () {( &__X32_SYSCALL_BIT + 212);}' unless defined(&__NR_lookup_dcookie);
    eval 'sub __NR_epoll_create () {( &__X32_SYSCALL_BIT + 213);}' unless defined(&__NR_epoll_create);
    eval 'sub __NR_remap_file_pages () {( &__X32_SYSCALL_BIT + 216);}' unless defined(&__NR_remap_file_pages);
    eval 'sub __NR_getdents64 () {( &__X32_SYSCALL_BIT + 217);}' unless defined(&__NR_getdents64);
    eval 'sub __NR_set_tid_address () {( &__X32_SYSCALL_BIT + 218);}' unless defined(&__NR_set_tid_address);
    eval 'sub __NR_restart_syscall () {( &__X32_SYSCALL_BIT + 219);}' unless defined(&__NR_restart_syscall);
    eval 'sub __NR_semtimedop () {( &__X32_SYSCALL_BIT + 220);}' unless defined(&__NR_semtimedop);
    eval 'sub __NR_fadvise64 () {( &__X32_SYSCALL_BIT + 221);}' unless defined(&__NR_fadvise64);
    eval 'sub __NR_timer_settime () {( &__X32_SYSCALL_BIT + 223);}' unless defined(&__NR_timer_settime);
    eval 'sub __NR_timer_gettime () {( &__X32_SYSCALL_BIT + 224);}' unless defined(&__NR_timer_gettime);
    eval 'sub __NR_timer_getoverrun () {( &__X32_SYSCALL_BIT + 225);}' unless defined(&__NR_timer_getoverrun);
    eval 'sub __NR_timer_delete () {( &__X32_SYSCALL_BIT + 226);}' unless defined(&__NR_timer_delete);
    eval 'sub __NR_clock_settime () {( &__X32_SYSCALL_BIT + 227);}' unless defined(&__NR_clock_settime);
    eval 'sub __NR_clock_gettime () {( &__X32_SYSCALL_BIT + 228);}' unless defined(&__NR_clock_gettime);
    eval 'sub __NR_clock_getres () {( &__X32_SYSCALL_BIT + 229);}' unless defined(&__NR_clock_getres);
    eval 'sub __NR_clock_nanosleep () {( &__X32_SYSCALL_BIT + 230);}' unless defined(&__NR_clock_nanosleep);
    eval 'sub __NR_exit_group () {( &__X32_SYSCALL_BIT + 231);}' unless defined(&__NR_exit_group);
    eval 'sub __NR_epoll_wait () {( &__X32_SYSCALL_BIT + 232);}' unless defined(&__NR_epoll_wait);
    eval 'sub __NR_epoll_ctl () {( &__X32_SYSCALL_BIT + 233);}' unless defined(&__NR_epoll_ctl);
    eval 'sub __NR_tgkill () {( &__X32_SYSCALL_BIT + 234);}' unless defined(&__NR_tgkill);
    eval 'sub __NR_utimes () {( &__X32_SYSCALL_BIT + 235);}' unless defined(&__NR_utimes);
    eval 'sub __NR_mbind () {( &__X32_SYSCALL_BIT + 237);}' unless defined(&__NR_mbind);
    eval 'sub __NR_set_mempolicy () {( &__X32_SYSCALL_BIT + 238);}' unless defined(&__NR_set_mempolicy);
    eval 'sub __NR_get_mempolicy () {( &__X32_SYSCALL_BIT + 239);}' unless defined(&__NR_get_mempolicy);
    eval 'sub __NR_mq_open () {( &__X32_SYSCALL_BIT + 240);}' unless defined(&__NR_mq_open);
    eval 'sub __NR_mq_unlink () {( &__X32_SYSCALL_BIT + 241);}' unless defined(&__NR_mq_unlink);
    eval 'sub __NR_mq_timedsend () {( &__X32_SYSCALL_BIT + 242);}' unless defined(&__NR_mq_timedsend);
    eval 'sub __NR_mq_timedreceive () {( &__X32_SYSCALL_BIT + 243);}' unless defined(&__NR_mq_timedreceive);
    eval 'sub __NR_mq_getsetattr () {( &__X32_SYSCALL_BIT + 245);}' unless defined(&__NR_mq_getsetattr);
    eval 'sub __NR_add_key () {( &__X32_SYSCALL_BIT + 248);}' unless defined(&__NR_add_key);
    eval 'sub __NR_request_key () {( &__X32_SYSCALL_BIT + 249);}' unless defined(&__NR_request_key);
    eval 'sub __NR_keyctl () {( &__X32_SYSCALL_BIT + 250);}' unless defined(&__NR_keyctl);
    eval 'sub __NR_ioprio_set () {( &__X32_SYSCALL_BIT + 251);}' unless defined(&__NR_ioprio_set);
    eval 'sub __NR_ioprio_get () {( &__X32_SYSCALL_BIT + 252);}' unless defined(&__NR_ioprio_get);
    eval 'sub __NR_inotify_init () {( &__X32_SYSCALL_BIT + 253);}' unless defined(&__NR_inotify_init);
    eval 'sub __NR_inotify_add_watch () {( &__X32_SYSCALL_BIT + 254);}' unless defined(&__NR_inotify_add_watch);
    eval 'sub __NR_inotify_rm_watch () {( &__X32_SYSCALL_BIT + 255);}' unless defined(&__NR_inotify_rm_watch);
    eval 'sub __NR_migrate_pages () {( &__X32_SYSCALL_BIT + 256);}' unless defined(&__NR_migrate_pages);
    eval 'sub __NR_openat () {( &__X32_SYSCALL_BIT + 257);}' unless defined(&__NR_openat);
    eval 'sub __NR_mkdirat () {( &__X32_SYSCALL_BIT + 258);}' unless defined(&__NR_mkdirat);
    eval 'sub __NR_mknodat () {( &__X32_SYSCALL_BIT + 259);}' unless defined(&__NR_mknodat);
    eval 'sub __NR_fchownat () {( &__X32_SYSCALL_BIT + 260);}' unless defined(&__NR_fchownat);
    eval 'sub __NR_futimesat () {( &__X32_SYSCALL_BIT + 261);}' unless defined(&__NR_futimesat);
    eval 'sub __NR_newfstatat () {( &__X32_SYSCALL_BIT + 262);}' unless defined(&__NR_newfstatat);
    eval 'sub __NR_unlinkat () {( &__X32_SYSCALL_BIT + 263);}' unless defined(&__NR_unlinkat);
    eval 'sub __NR_renameat () {( &__X32_SYSCALL_BIT + 264);}' unless defined(&__NR_renameat);
    eval 'sub __NR_linkat () {( &__X32_SYSCALL_BIT + 265);}' unless defined(&__NR_linkat);
    eval 'sub __NR_symlinkat () {( &__X32_SYSCALL_BIT + 266);}' unless defined(&__NR_symlinkat);
    eval 'sub __NR_readlinkat () {( &__X32_SYSCALL_BIT + 267);}' unless defined(&__NR_readlinkat);
    eval 'sub __NR_fchmodat () {( &__X32_SYSCALL_BIT + 268);}' unless defined(&__NR_fchmodat);
    eval 'sub __NR_faccessat () {( &__X32_SYSCALL_BIT + 269);}' unless defined(&__NR_faccessat);
    eval 'sub __NR_pselect6 () {( &__X32_SYSCALL_BIT + 270);}' unless defined(&__NR_pselect6);
    eval 'sub __NR_ppoll () {( &__X32_SYSCALL_BIT + 271);}' unless defined(&__NR_ppoll);
    eval 'sub __NR_unshare () {( &__X32_SYSCALL_BIT + 272);}' unless defined(&__NR_unshare);
    eval 'sub __NR_splice () {( &__X32_SYSCALL_BIT + 275);}' unless defined(&__NR_splice);
    eval 'sub __NR_tee () {( &__X32_SYSCALL_BIT + 276);}' unless defined(&__NR_tee);
    eval 'sub __NR_sync_file_range () {( &__X32_SYSCALL_BIT + 277);}' unless defined(&__NR_sync_file_range);
    eval 'sub __NR_utimensat () {( &__X32_SYSCALL_BIT + 280);}' unless defined(&__NR_utimensat);
    eval 'sub __NR_epoll_pwait () {( &__X32_SYSCALL_BIT + 281);}' unless defined(&__NR_epoll_pwait);
    eval 'sub __NR_signalfd () {( &__X32_SYSCALL_BIT + 282);}' unless defined(&__NR_signalfd);
    eval 'sub __NR_timerfd_create () {( &__X32_SYSCALL_BIT + 283);}' unless defined(&__NR_timerfd_create);
    eval 'sub __NR_eventfd () {( &__X32_SYSCALL_BIT + 284);}' unless defined(&__NR_eventfd);
    eval 'sub __NR_fallocate () {( &__X32_SYSCALL_BIT + 285);}' unless defined(&__NR_fallocate);
    eval 'sub __NR_timerfd_settime () {( &__X32_SYSCALL_BIT + 286);}' unless defined(&__NR_timerfd_settime);
    eval 'sub __NR_timerfd_gettime () {( &__X32_SYSCALL_BIT + 287);}' unless defined(&__NR_timerfd_gettime);
    eval 'sub __NR_accept4 () {( &__X32_SYSCALL_BIT + 288);}' unless defined(&__NR_accept4);
    eval 'sub __NR_signalfd4 () {( &__X32_SYSCALL_BIT + 289);}' unless defined(&__NR_signalfd4);
    eval 'sub __NR_eventfd2 () {( &__X32_SYSCALL_BIT + 290);}' unless defined(&__NR_eventfd2);
    eval 'sub __NR_epoll_create1 () {( &__X32_SYSCALL_BIT + 291);}' unless defined(&__NR_epoll_create1);
    eval 'sub __NR_dup3 () {( &__X32_SYSCALL_BIT + 292);}' unless defined(&__NR_dup3);
    eval 'sub __NR_pipe2 () {( &__X32_SYSCALL_BIT + 293);}' unless defined(&__NR_pipe2);
    eval 'sub __NR_inotify_init1 () {( &__X32_SYSCALL_BIT + 294);}' unless defined(&__NR_inotify_init1);
    eval 'sub __NR_perf_event_open () {( &__X32_SYSCALL_BIT + 298);}' unless defined(&__NR_perf_event_open);
    eval 'sub __NR_fanotify_init () {( &__X32_SYSCALL_BIT + 300);}' unless defined(&__NR_fanotify_init);
    eval 'sub __NR_fanotify_mark () {( &__X32_SYSCALL_BIT + 301);}' unless defined(&__NR_fanotify_mark);
    eval 'sub __NR_prlimit64 () {( &__X32_SYSCALL_BIT + 302);}' unless defined(&__NR_prlimit64);
    eval 'sub __NR_name_to_handle_at () {( &__X32_SYSCALL_BIT + 303);}' unless defined(&__NR_name_to_handle_at);
    eval 'sub __NR_open_by_handle_at () {( &__X32_SYSCALL_BIT + 304);}' unless defined(&__NR_open_by_handle_at);
    eval 'sub __NR_clock_adjtime () {( &__X32_SYSCALL_BIT + 305);}' unless defined(&__NR_clock_adjtime);
    eval 'sub __NR_syncfs () {( &__X32_SYSCALL_BIT + 306);}' unless defined(&__NR_syncfs);
    eval 'sub __NR_setns () {( &__X32_SYSCALL_BIT + 308);}' unless defined(&__NR_setns);
    eval 'sub __NR_getcpu () {( &__X32_SYSCALL_BIT + 309);}' unless defined(&__NR_getcpu);
    eval 'sub __NR_kcmp () {( &__X32_SYSCALL_BIT + 312);}' unless defined(&__NR_kcmp);
    eval 'sub __NR_finit_module () {( &__X32_SYSCALL_BIT + 313);}' unless defined(&__NR_finit_module);
    eval 'sub __NR_sched_setattr () {( &__X32_SYSCALL_BIT + 314);}' unless defined(&__NR_sched_setattr);
    eval 'sub __NR_sched_getattr () {( &__X32_SYSCALL_BIT + 315);}' unless defined(&__NR_sched_getattr);
    eval 'sub __NR_renameat2 () {( &__X32_SYSCALL_BIT + 316);}' unless defined(&__NR_renameat2);
    eval 'sub __NR_seccomp () {( &__X32_SYSCALL_BIT + 317);}' unless defined(&__NR_seccomp);
    eval 'sub __NR_getrandom () {( &__X32_SYSCALL_BIT + 318);}' unless defined(&__NR_getrandom);
    eval 'sub __NR_memfd_create () {( &__X32_SYSCALL_BIT + 319);}' unless defined(&__NR_memfd_create);
    eval 'sub __NR_kexec_file_load () {( &__X32_SYSCALL_BIT + 320);}' unless defined(&__NR_kexec_file_load);
    eval 'sub __NR_bpf () {( &__X32_SYSCALL_BIT + 321);}' unless defined(&__NR_bpf);
    eval 'sub __NR_userfaultfd () {( &__X32_SYSCALL_BIT + 323);}' unless defined(&__NR_userfaultfd);
    eval 'sub __NR_membarrier () {( &__X32_SYSCALL_BIT + 324);}' unless defined(&__NR_membarrier);
    eval 'sub __NR_mlock2 () {( &__X32_SYSCALL_BIT + 325);}' unless defined(&__NR_mlock2);
    eval 'sub __NR_copy_file_range () {( &__X32_SYSCALL_BIT + 326);}' unless defined(&__NR_copy_file_range);
    eval 'sub __NR_pkey_mprotect () {( &__X32_SYSCALL_BIT + 329);}' unless defined(&__NR_pkey_mprotect);
    eval 'sub __NR_pkey_alloc () {( &__X32_SYSCALL_BIT + 330);}' unless defined(&__NR_pkey_alloc);
    eval 'sub __NR_pkey_free () {( &__X32_SYSCALL_BIT + 331);}' unless defined(&__NR_pkey_free);
    eval 'sub __NR_statx () {( &__X32_SYSCALL_BIT + 332);}' unless defined(&__NR_statx);
    eval 'sub __NR_io_pgetevents () {( &__X32_SYSCALL_BIT + 333);}' unless defined(&__NR_io_pgetevents);
    eval 'sub __NR_rseq () {( &__X32_SYSCALL_BIT + 334);}' unless defined(&__NR_rseq);
    eval 'sub __NR_pidfd_send_signal () {( &__X32_SYSCALL_BIT + 424);}' unless defined(&__NR_pidfd_send_signal);
    eval 'sub __NR_io_uring_setup () {( &__X32_SYSCALL_BIT + 425);}' unless defined(&__NR_io_uring_setup);
    eval 'sub __NR_io_uring_enter () {( &__X32_SYSCALL_BIT + 426);}' unless defined(&__NR_io_uring_enter);
    eval 'sub __NR_io_uring_register () {( &__X32_SYSCALL_BIT + 427);}' unless defined(&__NR_io_uring_register);
    eval 'sub __NR_open_tree () {( &__X32_SYSCALL_BIT + 428);}' unless defined(&__NR_open_tree);
    eval 'sub __NR_move_mount () {( &__X32_SYSCALL_BIT + 429);}' unless defined(&__NR_move_mount);
    eval 'sub __NR_fsopen () {( &__X32_SYSCALL_BIT + 430);}' unless defined(&__NR_fsopen);
    eval 'sub __NR_fsconfig () {( &__X32_SYSCALL_BIT + 431);}' unless defined(&__NR_fsconfig);
    eval 'sub __NR_fsmount () {( &__X32_SYSCALL_BIT + 432);}' unless defined(&__NR_fsmount);
    eval 'sub __NR_fspick () {( &__X32_SYSCALL_BIT + 433);}' unless defined(&__NR_fspick);
    eval 'sub __NR_pidfd_open () {( &__X32_SYSCALL_BIT + 434);}' unless defined(&__NR_pidfd_open);
    eval 'sub __NR_clone3 () {( &__X32_SYSCALL_BIT + 435);}' unless defined(&__NR_clone3);
    eval 'sub __NR_rt_sigaction () {( &__X32_SYSCALL_BIT + 512);}' unless defined(&__NR_rt_sigaction);
    eval 'sub __NR_rt_sigreturn () {( &__X32_SYSCALL_BIT + 513);}' unless defined(&__NR_rt_sigreturn);
    eval 'sub __NR_ioctl () {( &__X32_SYSCALL_BIT + 514);}' unless defined(&__NR_ioctl);
    eval 'sub __NR_readv () {( &__X32_SYSCALL_BIT + 515);}' unless defined(&__NR_readv);
    eval 'sub __NR_writev () {( &__X32_SYSCALL_BIT + 516);}' unless defined(&__NR_writev);
    eval 'sub __NR_recvfrom () {( &__X32_SYSCALL_BIT + 517);}' unless defined(&__NR_recvfrom);
    eval 'sub __NR_sendmsg () {( &__X32_SYSCALL_BIT + 518);}' unless defined(&__NR_sendmsg);
    eval 'sub __NR_recvmsg () {( &__X32_SYSCALL_BIT + 519);}' unless defined(&__NR_recvmsg);
    eval 'sub __NR_execve () {( &__X32_SYSCALL_BIT + 520);}' unless defined(&__NR_execve);
    eval 'sub __NR_ptrace () {( &__X32_SYSCALL_BIT + 521);}' unless defined(&__NR_ptrace);
    eval 'sub __NR_rt_sigpending () {( &__X32_SYSCALL_BIT + 522);}' unless defined(&__NR_rt_sigpending);
    eval 'sub __NR_rt_sigtimedwait () {( &__X32_SYSCALL_BIT + 523);}' unless defined(&__NR_rt_sigtimedwait);
    eval 'sub __NR_rt_sigqueueinfo () {( &__X32_SYSCALL_BIT + 524);}' unless defined(&__NR_rt_sigqueueinfo);
    eval 'sub __NR_sigaltstack () {( &__X32_SYSCALL_BIT + 525);}' unless defined(&__NR_sigaltstack);
    eval 'sub __NR_timer_create () {( &__X32_SYSCALL_BIT + 526);}' unless defined(&__NR_timer_create);
    eval 'sub __NR_mq_notify () {( &__X32_SYSCALL_BIT + 527);}' unless defined(&__NR_mq_notify);
    eval 'sub __NR_kexec_load () {( &__X32_SYSCALL_BIT + 528);}' unless defined(&__NR_kexec_load);
    eval 'sub __NR_waitid () {( &__X32_SYSCALL_BIT + 529);}' unless defined(&__NR_waitid);
    eval 'sub __NR_set_robust_list () {( &__X32_SYSCALL_BIT + 530);}' unless defined(&__NR_set_robust_list);
    eval 'sub __NR_get_robust_list () {( &__X32_SYSCALL_BIT + 531);}' unless defined(&__NR_get_robust_list);
    eval 'sub __NR_vmsplice () {( &__X32_SYSCALL_BIT + 532);}' unless defined(&__NR_vmsplice);
    eval 'sub __NR_move_pages () {( &__X32_SYSCALL_BIT + 533);}' unless defined(&__NR_move_pages);
    eval 'sub __NR_preadv () {( &__X32_SYSCALL_BIT + 534);}' unless defined(&__NR_preadv);
    eval 'sub __NR_pwritev () {( &__X32_SYSCALL_BIT + 535);}' unless defined(&__NR_pwritev);
    eval 'sub __NR_rt_tgsigqueueinfo () {( &__X32_SYSCALL_BIT + 536);}' unless defined(&__NR_rt_tgsigqueueinfo);
    eval 'sub __NR_recvmmsg () {( &__X32_SYSCALL_BIT + 537);}' unless defined(&__NR_recvmmsg);
    eval 'sub __NR_sendmmsg () {( &__X32_SYSCALL_BIT + 538);}' unless defined(&__NR_sendmmsg);
    eval 'sub __NR_process_vm_readv () {( &__X32_SYSCALL_BIT + 539);}' unless defined(&__NR_process_vm_readv);
    eval 'sub __NR_process_vm_writev () {( &__X32_SYSCALL_BIT + 540);}' unless defined(&__NR_process_vm_writev);
    eval 'sub __NR_setsockopt () {( &__X32_SYSCALL_BIT + 541);}' unless defined(&__NR_setsockopt);
    eval 'sub __NR_getsockopt () {( &__X32_SYSCALL_BIT + 542);}' unless defined(&__NR_getsockopt);
    eval 'sub __NR_io_setup () {( &__X32_SYSCALL_BIT + 543);}' unless defined(&__NR_io_setup);
    eval 'sub __NR_io_submit () {( &__X32_SYSCALL_BIT + 544);}' unless defined(&__NR_io_submit);
    eval 'sub __NR_execveat () {( &__X32_SYSCALL_BIT + 545);}' unless defined(&__NR_execveat);
    eval 'sub __NR_preadv2 () {( &__X32_SYSCALL_BIT + 546);}' unless defined(&__NR_preadv2);
    eval 'sub __NR_pwritev2 () {( &__X32_SYSCALL_BIT + 547);}' unless defined(&__NR_pwritev2);
}
1;
