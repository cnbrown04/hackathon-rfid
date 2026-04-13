pub const __builtin_bswap16 = @import("std").zig.c_builtins.__builtin_bswap16;
pub const __builtin_bswap32 = @import("std").zig.c_builtins.__builtin_bswap32;
pub const __builtin_bswap64 = @import("std").zig.c_builtins.__builtin_bswap64;
pub const __builtin_signbit = @import("std").zig.c_builtins.__builtin_signbit;
pub const __builtin_signbitf = @import("std").zig.c_builtins.__builtin_signbitf;
pub const __builtin_popcount = @import("std").zig.c_builtins.__builtin_popcount;
pub const __builtin_ctz = @import("std").zig.c_builtins.__builtin_ctz;
pub const __builtin_clz = @import("std").zig.c_builtins.__builtin_clz;
pub const __builtin_sqrt = @import("std").zig.c_builtins.__builtin_sqrt;
pub const __builtin_sqrtf = @import("std").zig.c_builtins.__builtin_sqrtf;
pub const __builtin_sin = @import("std").zig.c_builtins.__builtin_sin;
pub const __builtin_sinf = @import("std").zig.c_builtins.__builtin_sinf;
pub const __builtin_cos = @import("std").zig.c_builtins.__builtin_cos;
pub const __builtin_cosf = @import("std").zig.c_builtins.__builtin_cosf;
pub const __builtin_exp = @import("std").zig.c_builtins.__builtin_exp;
pub const __builtin_expf = @import("std").zig.c_builtins.__builtin_expf;
pub const __builtin_exp2 = @import("std").zig.c_builtins.__builtin_exp2;
pub const __builtin_exp2f = @import("std").zig.c_builtins.__builtin_exp2f;
pub const __builtin_log = @import("std").zig.c_builtins.__builtin_log;
pub const __builtin_logf = @import("std").zig.c_builtins.__builtin_logf;
pub const __builtin_log2 = @import("std").zig.c_builtins.__builtin_log2;
pub const __builtin_log2f = @import("std").zig.c_builtins.__builtin_log2f;
pub const __builtin_log10 = @import("std").zig.c_builtins.__builtin_log10;
pub const __builtin_log10f = @import("std").zig.c_builtins.__builtin_log10f;
pub const __builtin_abs = @import("std").zig.c_builtins.__builtin_abs;
pub const __builtin_labs = @import("std").zig.c_builtins.__builtin_labs;
pub const __builtin_llabs = @import("std").zig.c_builtins.__builtin_llabs;
pub const __builtin_fabs = @import("std").zig.c_builtins.__builtin_fabs;
pub const __builtin_fabsf = @import("std").zig.c_builtins.__builtin_fabsf;
pub const __builtin_floor = @import("std").zig.c_builtins.__builtin_floor;
pub const __builtin_floorf = @import("std").zig.c_builtins.__builtin_floorf;
pub const __builtin_ceil = @import("std").zig.c_builtins.__builtin_ceil;
pub const __builtin_ceilf = @import("std").zig.c_builtins.__builtin_ceilf;
pub const __builtin_trunc = @import("std").zig.c_builtins.__builtin_trunc;
pub const __builtin_truncf = @import("std").zig.c_builtins.__builtin_truncf;
pub const __builtin_round = @import("std").zig.c_builtins.__builtin_round;
pub const __builtin_roundf = @import("std").zig.c_builtins.__builtin_roundf;
pub const __builtin_strlen = @import("std").zig.c_builtins.__builtin_strlen;
pub const __builtin_strcmp = @import("std").zig.c_builtins.__builtin_strcmp;
pub const __builtin_object_size = @import("std").zig.c_builtins.__builtin_object_size;
pub const __builtin___memset_chk = @import("std").zig.c_builtins.__builtin___memset_chk;
pub const __builtin_memset = @import("std").zig.c_builtins.__builtin_memset;
pub const __builtin___memcpy_chk = @import("std").zig.c_builtins.__builtin___memcpy_chk;
pub const __builtin_memcpy = @import("std").zig.c_builtins.__builtin_memcpy;
pub const __builtin_expect = @import("std").zig.c_builtins.__builtin_expect;
pub const __builtin_nanf = @import("std").zig.c_builtins.__builtin_nanf;
pub const __builtin_huge_valf = @import("std").zig.c_builtins.__builtin_huge_valf;
pub const __builtin_inff = @import("std").zig.c_builtins.__builtin_inff;
pub const __builtin_isnan = @import("std").zig.c_builtins.__builtin_isnan;
pub const __builtin_isinf = @import("std").zig.c_builtins.__builtin_isinf;
pub const __builtin_isinf_sign = @import("std").zig.c_builtins.__builtin_isinf_sign;
pub const __has_builtin = @import("std").zig.c_builtins.__has_builtin;
pub const __builtin_assume = @import("std").zig.c_builtins.__builtin_assume;
pub const __builtin_unreachable = @import("std").zig.c_builtins.__builtin_unreachable;
pub const __builtin_constant_p = @import("std").zig.c_builtins.__builtin_constant_p;
pub const __builtin_mul_overflow = @import("std").zig.c_builtins.__builtin_mul_overflow;
pub const INT8 = i8;
pub const UINT8 = u8;
pub const INT16 = c_short;
pub const UINT16 = c_ushort;
pub const INT32 = c_int;
pub const UINT32 = c_uint;
pub const FLOAT = f32;
pub const ULONG = c_ulong;
pub const __u_char = u8;
pub const __u_short = c_ushort;
pub const __u_int = c_uint;
pub const __u_long = c_ulong;
pub const __int8_t = i8;
pub const __uint8_t = u8;
pub const __int16_t = c_short;
pub const __uint16_t = c_ushort;
pub const __int32_t = c_int;
pub const __uint32_t = c_uint;
pub const __int64_t = c_long;
pub const __uint64_t = c_ulong;
pub const __int_least8_t = __int8_t;
pub const __uint_least8_t = __uint8_t;
pub const __int_least16_t = __int16_t;
pub const __uint_least16_t = __uint16_t;
pub const __int_least32_t = __int32_t;
pub const __uint_least32_t = __uint32_t;
pub const __int_least64_t = __int64_t;
pub const __uint_least64_t = __uint64_t;
pub const __quad_t = c_long;
pub const __u_quad_t = c_ulong;
pub const __intmax_t = c_long;
pub const __uintmax_t = c_ulong;
pub const __dev_t = c_ulong;
pub const __uid_t = c_uint;
pub const __gid_t = c_uint;
pub const __ino_t = c_ulong;
pub const __ino64_t = c_ulong;
pub const __mode_t = c_uint;
pub const __nlink_t = c_ulong;
pub const __off_t = c_long;
pub const __off64_t = c_long;
pub const __pid_t = c_int;
pub const __fsid_t = extern struct {
    __val: [2]c_int = @import("std").mem.zeroes([2]c_int),
};
pub const __clock_t = c_long;
pub const __rlim_t = c_ulong;
pub const __rlim64_t = c_ulong;
pub const __id_t = c_uint;
pub const __time_t = c_long;
pub const __useconds_t = c_uint;
pub const __suseconds_t = c_long;
pub const __suseconds64_t = c_long;
pub const __daddr_t = c_int;
pub const __key_t = c_int;
pub const __clockid_t = c_int;
pub const __timer_t = ?*anyopaque;
pub const __blksize_t = c_long;
pub const __blkcnt_t = c_long;
pub const __blkcnt64_t = c_long;
pub const __fsblkcnt_t = c_ulong;
pub const __fsblkcnt64_t = c_ulong;
pub const __fsfilcnt_t = c_ulong;
pub const __fsfilcnt64_t = c_ulong;
pub const __fsword_t = c_long;
pub const __ssize_t = c_long;
pub const __syscall_slong_t = c_long;
pub const __syscall_ulong_t = c_ulong;
pub const __loff_t = __off64_t;
pub const __caddr_t = [*c]u8;
pub const __intptr_t = c_long;
pub const __socklen_t = c_uint;
pub const __sig_atomic_t = c_int;
pub const int_least8_t = __int_least8_t;
pub const int_least16_t = __int_least16_t;
pub const int_least32_t = __int_least32_t;
pub const int_least64_t = __int_least64_t;
pub const uint_least8_t = __uint_least8_t;
pub const uint_least16_t = __uint_least16_t;
pub const uint_least32_t = __uint_least32_t;
pub const uint_least64_t = __uint_least64_t;
pub const int_fast8_t = i8;
pub const int_fast16_t = c_long;
pub const int_fast32_t = c_long;
pub const int_fast64_t = c_long;
pub const uint_fast8_t = u8;
pub const uint_fast16_t = c_ulong;
pub const uint_fast32_t = c_ulong;
pub const uint_fast64_t = c_ulong;
pub const intmax_t = __intmax_t;
pub const uintmax_t = __uintmax_t;
pub const __gwchar_t = c_int;
pub const imaxdiv_t = extern struct {
    quot: c_long = @import("std").mem.zeroes(c_long),
    rem: c_long = @import("std").mem.zeroes(c_long),
};
pub extern fn imaxabs(__n: intmax_t) intmax_t;
pub extern fn imaxdiv(__numer: intmax_t, __denom: intmax_t) imaxdiv_t;
pub extern fn strtoimax(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) intmax_t;
pub extern fn strtoumax(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) uintmax_t;
pub extern fn wcstoimax(noalias __nptr: [*c]const __gwchar_t, noalias __endptr: [*c][*c]__gwchar_t, __base: c_int) intmax_t;
pub extern fn wcstoumax(noalias __nptr: [*c]const __gwchar_t, noalias __endptr: [*c][*c]__gwchar_t, __base: c_int) uintmax_t;
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/x86-linux-gnu/bits/floatn.h:83:24: warning: unsupported type: 'Complex'
pub const __cfloat128 = @compileError("unable to resolve typedef child type");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/x86-linux-gnu/bits/floatn.h:83:24
pub const _Float128 = f128;
pub const _Float32 = f32;
pub const _Float64 = f64;
pub const _Float32x = f64;
pub const _Float64x = c_longdouble;
pub const wchar_t = c_int;
pub const struct___va_list_tag_1 = extern struct {
    gp_offset: c_uint = @import("std").mem.zeroes(c_uint),
    fp_offset: c_uint = @import("std").mem.zeroes(c_uint),
    overflow_arg_area: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reg_save_area: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const __builtin_va_list = [1]struct___va_list_tag_1;
pub const __gnuc_va_list = __builtin_va_list;
pub const va_list = __gnuc_va_list;
pub const wint_t = c_uint;
const union_unnamed_2 = extern union {
    __wch: c_uint,
    __wchb: [4]u8,
};
pub const __mbstate_t = extern struct {
    __count: c_int = @import("std").mem.zeroes(c_int),
    __value: union_unnamed_2 = @import("std").mem.zeroes(union_unnamed_2),
};
pub const mbstate_t = __mbstate_t;
pub const struct__IO_FILE = opaque {};
pub const __FILE = struct__IO_FILE;
pub const FILE = struct__IO_FILE;
pub const struct___locale_data_3 = opaque {};
pub const struct___locale_struct = extern struct {
    __locales: [13]?*struct___locale_data_3 = @import("std").mem.zeroes([13]?*struct___locale_data_3),
    __ctype_b: [*c]const c_ushort = @import("std").mem.zeroes([*c]const c_ushort),
    __ctype_tolower: [*c]const c_int = @import("std").mem.zeroes([*c]const c_int),
    __ctype_toupper: [*c]const c_int = @import("std").mem.zeroes([*c]const c_int),
    __names: [13][*c]const u8 = @import("std").mem.zeroes([13][*c]const u8),
};
pub const __locale_t = [*c]struct___locale_struct;
pub const locale_t = __locale_t;
pub const struct_tm = opaque {};
pub extern fn wcscpy(noalias __dest: [*c]wchar_t, noalias __src: [*c]const wchar_t) [*c]wchar_t;
pub extern fn wcsncpy(noalias __dest: [*c]wchar_t, noalias __src: [*c]const wchar_t, __n: usize) [*c]wchar_t;
pub extern fn wcslcpy(noalias __dest: [*c]wchar_t, noalias __src: [*c]const wchar_t, __n: usize) usize;
pub extern fn wcslcat(noalias __dest: [*c]wchar_t, noalias __src: [*c]const wchar_t, __n: usize) usize;
pub extern fn wcscat(noalias __dest: [*c]wchar_t, noalias __src: [*c]const wchar_t) [*c]wchar_t;
pub extern fn wcsncat(noalias __dest: [*c]wchar_t, noalias __src: [*c]const wchar_t, __n: usize) [*c]wchar_t;
pub extern fn wcscmp(__s1: [*c]const c_int, __s2: [*c]const c_int) c_int;
pub extern fn wcsncmp(__s1: [*c]const c_int, __s2: [*c]const c_int, __n: c_ulong) c_int;
pub extern fn wcscasecmp(__s1: [*c]const wchar_t, __s2: [*c]const wchar_t) c_int;
pub extern fn wcsncasecmp(__s1: [*c]const wchar_t, __s2: [*c]const wchar_t, __n: usize) c_int;
pub extern fn wcscasecmp_l(__s1: [*c]const wchar_t, __s2: [*c]const wchar_t, __loc: locale_t) c_int;
pub extern fn wcsncasecmp_l(__s1: [*c]const wchar_t, __s2: [*c]const wchar_t, __n: usize, __loc: locale_t) c_int;
pub extern fn wcscoll(__s1: [*c]const wchar_t, __s2: [*c]const wchar_t) c_int;
pub extern fn wcsxfrm(noalias __s1: [*c]wchar_t, noalias __s2: [*c]const wchar_t, __n: usize) usize;
pub extern fn wcscoll_l(__s1: [*c]const wchar_t, __s2: [*c]const wchar_t, __loc: locale_t) c_int;
pub extern fn wcsxfrm_l(__s1: [*c]wchar_t, __s2: [*c]const wchar_t, __n: usize, __loc: locale_t) usize;
pub extern fn wcsdup(__s: [*c]const wchar_t) [*c]wchar_t;
pub extern fn wcschr(__wcs: [*c]const c_int, __wc: c_int) [*c]c_int;
pub extern fn wcsrchr(__wcs: [*c]const wchar_t, __wc: wchar_t) [*c]wchar_t;
pub extern fn wcscspn(__wcs: [*c]const wchar_t, __reject: [*c]const wchar_t) usize;
pub extern fn wcsspn(__wcs: [*c]const wchar_t, __accept: [*c]const wchar_t) usize;
pub extern fn wcspbrk(__wcs: [*c]const wchar_t, __accept: [*c]const wchar_t) [*c]wchar_t;
pub extern fn wcsstr(__haystack: [*c]const wchar_t, __needle: [*c]const wchar_t) [*c]wchar_t;
pub extern fn wcstok(noalias __s: [*c]wchar_t, noalias __delim: [*c]const wchar_t, noalias __ptr: [*c][*c]wchar_t) [*c]wchar_t;
pub extern fn wcslen(__s: [*c]const c_int) c_ulong;
pub extern fn wcsnlen(__s: [*c]const wchar_t, __maxlen: usize) usize;
pub extern fn wmemchr(__s: [*c]const c_int, __c: c_int, __n: c_ulong) [*c]c_int;
pub extern fn wmemcmp(__s1: [*c]const c_int, __s2: [*c]const c_int, __n: c_ulong) c_int;
pub extern fn wmemcpy(__s1: [*c]c_int, __s2: [*c]const c_int, __n: c_ulong) [*c]c_int;
pub extern fn wmemmove(__s1: [*c]c_int, __s2: [*c]const c_int, __n: c_ulong) [*c]c_int;
pub extern fn wmemset(__s: [*c]wchar_t, __c: wchar_t, __n: usize) [*c]wchar_t;
pub extern fn btowc(__c: c_int) wint_t;
pub extern fn wctob(__c: wint_t) c_int;
pub extern fn mbsinit(__ps: [*c]const mbstate_t) c_int;
pub extern fn mbrtowc(noalias __pwc: [*c]wchar_t, noalias __s: [*c]const u8, __n: usize, noalias __p: [*c]mbstate_t) usize;
pub extern fn wcrtomb(noalias __s: [*c]u8, __wc: wchar_t, noalias __ps: [*c]mbstate_t) usize;
pub extern fn __mbrlen(noalias __s: [*c]const u8, __n: usize, noalias __ps: [*c]mbstate_t) usize;
pub extern fn mbrlen(noalias __s: [*c]const u8, __n: usize, noalias __ps: [*c]mbstate_t) usize;
pub extern fn mbsrtowcs(noalias __dst: [*c]wchar_t, noalias __src: [*c][*c]const u8, __len: usize, noalias __ps: [*c]mbstate_t) usize;
pub extern fn wcsrtombs(noalias __dst: [*c]u8, noalias __src: [*c][*c]const wchar_t, __len: usize, noalias __ps: [*c]mbstate_t) usize;
pub extern fn mbsnrtowcs(noalias __dst: [*c]wchar_t, noalias __src: [*c][*c]const u8, __nmc: usize, __len: usize, noalias __ps: [*c]mbstate_t) usize;
pub extern fn wcsnrtombs(noalias __dst: [*c]u8, noalias __src: [*c][*c]const wchar_t, __nwc: usize, __len: usize, noalias __ps: [*c]mbstate_t) usize;
pub extern fn wcstod(noalias __nptr: [*c]const wchar_t, noalias __endptr: [*c][*c]wchar_t) f64;
pub extern fn wcstof(noalias __nptr: [*c]const wchar_t, noalias __endptr: [*c][*c]wchar_t) f32;
pub extern fn wcstold(noalias __nptr: [*c]const wchar_t, noalias __endptr: [*c][*c]wchar_t) c_longdouble;
pub extern fn wcstol(noalias __nptr: [*c]const wchar_t, noalias __endptr: [*c][*c]wchar_t, __base: c_int) c_long;
pub extern fn wcstoul(noalias __nptr: [*c]const wchar_t, noalias __endptr: [*c][*c]wchar_t, __base: c_int) c_ulong;
pub extern fn wcstoll(noalias __nptr: [*c]const wchar_t, noalias __endptr: [*c][*c]wchar_t, __base: c_int) c_longlong;
pub extern fn wcstoull(noalias __nptr: [*c]const wchar_t, noalias __endptr: [*c][*c]wchar_t, __base: c_int) c_ulonglong;
pub extern fn wcpcpy(noalias __dest: [*c]wchar_t, noalias __src: [*c]const wchar_t) [*c]wchar_t;
pub extern fn wcpncpy(noalias __dest: [*c]wchar_t, noalias __src: [*c]const wchar_t, __n: usize) [*c]wchar_t;
pub extern fn open_wmemstream(__bufloc: [*c][*c]wchar_t, __sizeloc: [*c]usize) ?*__FILE;
pub extern fn fwide(__fp: ?*__FILE, __mode: c_int) c_int;
pub extern fn fwprintf(noalias __stream: ?*__FILE, noalias __format: [*c]const wchar_t, ...) c_int;
pub extern fn wprintf(noalias __format: [*c]const wchar_t, ...) c_int;
pub extern fn swprintf(noalias __s: [*c]wchar_t, __n: usize, noalias __format: [*c]const wchar_t, ...) c_int;
pub extern fn vfwprintf(noalias __s: ?*__FILE, noalias __format: [*c]const wchar_t, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vwprintf(noalias __format: [*c]const wchar_t, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vswprintf(noalias __s: [*c]wchar_t, __n: usize, noalias __format: [*c]const wchar_t, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn fwscanf(noalias __stream: ?*__FILE, noalias __format: [*c]const wchar_t, ...) c_int;
pub extern fn wscanf(noalias __format: [*c]const wchar_t, ...) c_int;
pub extern fn swscanf(noalias __s: [*c]const wchar_t, noalias __format: [*c]const wchar_t, ...) c_int;
pub extern fn vfwscanf(noalias __s: ?*__FILE, noalias __format: [*c]const wchar_t, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vwscanf(noalias __format: [*c]const wchar_t, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vswscanf(noalias __s: [*c]const wchar_t, noalias __format: [*c]const wchar_t, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn fgetwc(__stream: ?*__FILE) wint_t;
pub extern fn getwc(__stream: ?*__FILE) wint_t;
pub extern fn getwchar() wint_t;
pub extern fn fputwc(__wc: wchar_t, __stream: ?*__FILE) wint_t;
pub extern fn putwc(__wc: wchar_t, __stream: ?*__FILE) wint_t;
pub extern fn putwchar(__wc: wchar_t) wint_t;
pub extern fn fgetws(noalias __ws: [*c]wchar_t, __n: c_int, noalias __stream: ?*__FILE) [*c]wchar_t;
pub extern fn fputws(noalias __ws: [*c]const wchar_t, noalias __stream: ?*__FILE) c_int;
pub extern fn ungetwc(__wc: wint_t, __stream: ?*__FILE) wint_t;
pub extern fn wcsftime(noalias __s: [*c]wchar_t, __maxsize: usize, noalias __format: [*c]const wchar_t, noalias __tp: ?*const struct_tm) usize;
pub const WCHAR = wchar_t;
pub const LPVOID = ?*anyopaque;
pub const CHAR = u8;
pub const BYTE = u8;
pub const WORD = c_ushort;
pub const BOOLEAN = BYTE;
pub const INT64 = i64;
pub const RFID_HANDLE64 = u64;
pub const UINT64 = u64;
pub const SOCKET_HANDLE = u64;
pub const struct__SYSTEMTIME = extern struct {
    wYear: WORD = @import("std").mem.zeroes(WORD),
    wMonth: WORD = @import("std").mem.zeroes(WORD),
    wDayOfWeek: WORD = @import("std").mem.zeroes(WORD),
    wDay: WORD = @import("std").mem.zeroes(WORD),
    wHour: WORD = @import("std").mem.zeroes(WORD),
    wMinute: WORD = @import("std").mem.zeroes(WORD),
    wSecond: WORD = @import("std").mem.zeroes(WORD),
    wMilliseconds: WORD = @import("std").mem.zeroes(WORD),
};
pub const SYSTEMTIME = struct__SYSTEMTIME;
pub const PSYSTEMTIME = [*c]struct__SYSTEMTIME;
pub const LPSYSTEMTIME = [*c]struct__SYSTEMTIME;
pub const RFID_HANDLE32 = ?*anyopaque;
pub const EVENT_HANDLE = ?*anyopaque;
pub const STRUCT_HANDLE = ?*anyopaque;
pub const RFID_API3_5_0: c_int = 0;
pub const RFID_API3_5_1: c_int = 1;
pub const RFID_API3_5_5: c_int = 2;
pub const RFID_API3_5_6: c_int = 3;
pub const RFID_API3_5_7: c_int = 4;
pub const enum__RFID_VERSION = c_uint;
pub const RFID_VERSION = enum__RFID_VERSION;
pub const GPI_EVENT: c_int = 0;
pub const TAG_DATA_EVENT: c_int = 1;
pub const TAG_READ_EVENT: c_int = 1;
pub const BUFFER_FULL_WARNING_EVENT: c_int = 2;
pub const ANTENNA_EVENT: c_int = 3;
pub const INVENTORY_START_EVENT: c_int = 4;
pub const INVENTORY_STOP_EVENT: c_int = 5;
pub const ACCESS_START_EVENT: c_int = 6;
pub const ACCESS_STOP_EVENT: c_int = 7;
pub const DISCONNECTION_EVENT: c_int = 8;
pub const BUFFER_FULL_EVENT: c_int = 9;
pub const NXP_EAS_ALARM_EVENT: c_int = 10;
pub const READER_EXCEPTION_EVENT: c_int = 11;
pub const HANDHELD_TRIGGER_EVENT: c_int = 12;
pub const DEBUG_INFO_EVENT: c_int = 13;
pub const TEMPERATURE_ALARM_EVENT: c_int = 14;
pub const RF_SURVEY_DATA_READ_EVENT: c_int = 15;
pub const RF_SURVEY_START_EVENT: c_int = 16;
pub const RF_SURVEY_STOP_EVENT: c_int = 17;
pub const AUTONOMOUS_EVENT: c_int = 18;
pub const enum__RFID_EVENT_TYPE = c_uint;
pub const RFID_EVENT_TYPE = enum__RFID_EVENT_TYPE;
pub const UNKNOWN_EXCEPTION: c_int = 0;
pub const enum__READER_EXCEPTION_EVENT_TYPE = c_uint;
pub const READER_EXCEPTION_EVENT_TYPE = enum__READER_EXCEPTION_EVENT_TYPE;
pub const READER_INITIATED_DISCONNECTION: c_int = 0;
pub const READER_EXCEPTION: c_int = 1;
pub const CONNECTION_LOST: c_int = 2;
pub const enum__DISCONNECTION_EVENT_TYPE = c_uint;
pub const DISCONNECTION_EVENT_TYPE = enum__DISCONNECTION_EVENT_TYPE;
pub const ANTENNA_CONNECTED: c_int = 1;
pub const ANTENNA_DISCONNECTED: c_int = 0;
pub const enum__ANTENNA_EVENT_TYPE = c_uint;
pub const ANTENNA_EVENT_TYPE = enum__ANTENNA_EVENT_TYPE;
pub const GPI_PORT_STATE_LOW: c_int = 0;
pub const GPI_PORT_STATE_HIGH: c_int = 1;
pub const GPI_PORT_STATE_UNKNOWN: c_int = 2;
pub const enum__GPI_PORT_STATE = c_uint;
pub const GPI_PORT_STATE = enum__GPI_PORT_STATE;
pub const HANDHELD_TRIGGER_RELEASED: c_int = 0;
pub const HANDHELD_TRIGGER_PRESSED: c_int = 1;
pub const enum__HANDHELD_TRIGGER_EVENT_TYPE = c_uint;
pub const HANDHELD_TRIGGER_EVENT_TYPE = enum__HANDHELD_TRIGGER_EVENT_TYPE;
pub const MAC_ADDRESS: c_int = 0;
pub const EPC_ID: c_int = 1;
pub const enum__READER_ID_TYPE = c_uint;
pub const READER_ID_TYPE = enum__READER_ID_TYPE;
pub const FORWARD_LINK_MODULATION_PR_ASK: c_int = 0;
pub const FORWARD_LINK_MODULATION_SSB_ASK: c_int = 1;
pub const FORWARD_LINK_MODULATION_DSB_ASK: c_int = 2;
pub const enum__FORWARD_LINK_MODULATION = c_uint;
pub const FORWARD_LINK_MODULATION = enum__FORWARD_LINK_MODULATION;
pub const MV_FM0: c_int = 0;
pub const MV_2: c_int = 1;
pub const MV_4: c_int = 2;
pub const MV_8: c_int = 3;
pub const enum__MODULATION = c_uint;
pub const MODULATION = enum__MODULATION;
pub const DR_8: c_int = 0;
pub const DR_64_3: c_int = 1;
pub const enum__DIVIDE_RATIO = c_uint;
pub const DIVIDE_RATIO = enum__DIVIDE_RATIO;
pub const SMI_UNKNOWN: c_int = 0;
pub const SMI_SI: c_int = 1;
pub const SMI_MI: c_int = 2;
pub const SMI_DI: c_int = 3;
pub const enum__SPECTRAL_MASK_INDICATOR = c_uint;
pub const SPECTRAL_MASK_INDICATOR = enum__SPECTRAL_MASK_INDICATOR;
pub const UNSPECIFIED: c_int = 0;
pub const US_FCC_PART_15: c_int = 1;
pub const ETSI_302_208: c_int = 2;
pub const ETSI_300_220: c_int = 3;
pub const AUSTRALIA_LIPD_1W: c_int = 4;
pub const AUSTRALIA_LIPD_4W: c_int = 5;
pub const JAPAN_ARIB_STD_T89: c_int = 6;
pub const HONGKONG_OFTA_1049: c_int = 7;
pub const TAIWAN_DGT_LP0002: c_int = 8;
pub const KOREA_MIC_ARTICLE_5_2: c_int = 9;
pub const enum__COMMUNICATION_STANDARD = c_uint;
pub const COMMUNICATION_STANDARD = enum__COMMUNICATION_STANDARD;
pub const MEMORY_BANK_RESERVED: c_int = 0;
pub const MEMORY_BANK_EPC: c_int = 1;
pub const MEMORY_BANK_TID: c_int = 2;
pub const MEMORY_BANK_USER: c_int = 3;
pub const enum__MEMORY_BANK = c_uint;
pub const MEMORY_BANK = enum__MEMORY_BANK;
pub const START_TRIGGER_TYPE_IMMEDIATE: c_int = 0;
pub const START_TRIGGER_TYPE_PERIODIC: c_int = 1;
pub const START_TRIGGER_TYPE_GPI: c_int = 2;
pub const START_TRIGGER_TYPE_HANDHELD: c_int = 3;
pub const START_TRIGGER_TYPE_TIMELAPSE: c_int = 4;
pub const START_TRIGGER_TYPE_DISTANCE: c_int = 5;
pub const START_TRIGGER_TYPE_NONE: c_int = 6;
pub const enum__START_TRIGGER_TYPE = c_uint;
pub const START_TRIGGER_TYPE = enum__START_TRIGGER_TYPE;
pub const STOP_TRIGGER_TYPE_IMMEDIATE: c_int = 0;
pub const STOP_TRIGGER_TYPE_DURATION: c_int = 1;
pub const STOP_TRIGGER_TYPE_GPI_WITH_TIMEOUT: c_int = 2;
pub const STOP_TRIGGER_TYPE_TAG_OBSERVATION_WITH_TIMEOUT: c_int = 3;
pub const STOP_TRIGGER_TYPE_N_ATTEMPTS_WITH_TIMEOUT: c_int = 4;
pub const STOP_TRIGGER_TYPE_HANDHELD_WITH_TIMEOUT: c_int = 5;
pub const STOP_TRIGGER_TYPE_TIMELAPSE: c_int = 6;
pub const STOP_TRIGGER_TYPE_NONE: c_int = 7;
pub const enum__STOP_TRIGGER_TYPE = c_uint;
pub const STOP_TRIGGER_TYPE = enum__STOP_TRIGGER_TYPE;
pub const TRUNCATE_ACTION_UNSPECIFIED: c_int = 0;
pub const TRUNCATE_ACTION_DO_NOT_TRUNCATE: c_int = 1;
pub const TRUNCATE_ACTION_TRUNCATE: c_int = 2;
pub const enum__TRUNCATE_ACTION = c_uint;
pub const TRUNCATE_ACTION = enum__TRUNCATE_ACTION;
pub const SESSION_S0: c_int = 0;
pub const SESSION_S1: c_int = 1;
pub const SESSION_S2: c_int = 2;
pub const SESSION_S3: c_int = 3;
pub const enum__SESSION = c_uint;
pub const SESSION = enum__SESSION;
pub const INVENTORY_STATE_A: c_int = 0;
pub const INVENTORY_STATE_B: c_int = 1;
pub const INVENTORY_STATE_AB_FLIP: c_int = 2;
pub const enum__INVENTORY_STATE = c_uint;
pub const INVENTORY_STATE = enum__INVENTORY_STATE;
pub const FILTER_ACTION_DEFAULT: c_int = 0;
pub const FILTER_ACTION_STATE_AWARE: c_int = 1;
pub const FILTER_ACTION_STATE_UNAWARE: c_int = 2;
pub const enum__FILTER_ACTION = c_uint;
pub const FILTER_ACTION = enum__FILTER_ACTION;
pub const SL_FLAG_ASSERTED: c_int = 0;
pub const SL_FLAG_DEASSERTED: c_int = 1;
pub const SL_ALL: c_int = 2;
pub const enum__SL_FLAG = c_uint;
pub const SL_FLAG = enum__SL_FLAG;
pub const TARGET_SL: c_int = 0;
pub const TARGET_INVENTORIED_STATE_S0: c_int = 1;
pub const TARGET_INVENTORIED_STATE_S1: c_int = 2;
pub const TARGET_INVENTORIED_STATE_S2: c_int = 3;
pub const TARGET_INVENTORIED_STATE_S3: c_int = 4;
pub const enum__TARGET = c_uint;
pub const TARGET = enum__TARGET;
pub const STATE_UNAWARE_ACTION_SELECT_NOT_UNSELECT: c_int = 0;
pub const STATE_UNAWARE_ACTION_SELECT: c_int = 1;
pub const STATE_UNAWARE_ACTION_NOT_UNSELECT: c_int = 2;
pub const STATE_UNAWARE_ACTION_UNSELECT: c_int = 3;
pub const STATE_UNAWARE_ACTION_UNSELECT_NOT_SELECT: c_int = 4;
pub const STATE_UNAWARE_ACTION_NOT_SELECT: c_int = 5;
pub const enum__STATE_UNAWARE_ACTION = c_uint;
pub const STATE_UNAWARE_ACTION = enum__STATE_UNAWARE_ACTION;
pub const STATE_AWARE_ACTION_INV_A_NOT_INV_B: c_int = 0;
pub const STATE_AWARE_ACTION_ASRT_SL_NOT_DSRT_SL: c_int = 0;
pub const STATE_AWARE_ACTION_INV_A: c_int = 1;
pub const STATE_AWARE_ACTION_ASRT_SL: c_int = 1;
pub const STATE_AWARE_ACTION_NOT_INV_B: c_int = 2;
pub const STATE_AWARE_ACTION_NOT_DSRT_SL: c_int = 2;
pub const STATE_AWARE_ACTION_INV_A2BB2A: c_int = 3;
pub const STATE_AWARE_ACTION_INV_A2BB2A_NOT_INV_A: c_int = 3;
pub const STATE_AWARE_ACTION_NEG_SL: c_int = 3;
pub const STATE_AWARE_ACTION_NEG_SL_NOT_ASRT_SL: c_int = 3;
pub const STATE_AWARE_ACTION_INV_B_NOT_INV_A: c_int = 4;
pub const STATE_AWARE_ACTION_DSRT_SL_NOT_ASRT_SL: c_int = 4;
pub const STATE_AWARE_ACTION_INV_B: c_int = 5;
pub const STATE_AWARE_ACTION_DSRT_SL: c_int = 5;
pub const STATE_AWARE_ACTION_NOT_INV_A: c_int = 6;
pub const STATE_AWARE_ACTION_NOT_ASRT_SL: c_int = 6;
pub const STATE_AWARE_ACTION_NOT_INV_A2BB2A: c_int = 7;
pub const STATE_AWARE_ACTION_NOT_NEG_SL: c_int = 7;
pub const enum__STATE_AWARE_ACTION = c_uint;
pub const STATE_AWARE_ACTION = enum__STATE_AWARE_ACTION;
pub const LOCK_PRIVILEGE_NONE: c_int = 0;
pub const LOCK_PRIVILEGE_READ_WRITE: c_int = 1;
pub const LOCK_PRIVILEGE_PERMA_LOCK: c_int = 2;
pub const LOCK_PRIVILEGE_PERMA_UNLOCK: c_int = 3;
pub const LOCK_PRIVILEGE_UNLOCK: c_int = 4;
pub const enum__LOCK_PRIVILEGE = c_uint;
pub const LOCK_PRIVILEGE = enum__LOCK_PRIVILEGE;
pub const LOCK_KILL_PASSWORD: c_int = 0;
pub const LOCK_ACCESS_PASSWORD: c_int = 1;
pub const LOCK_EPC_MEMORY: c_int = 2;
pub const LOCK_TID_MEMORY: c_int = 3;
pub const LOCK_USER_MEMORY: c_int = 4;
pub const enum__LOCK_DATA_FIELD = c_uint;
pub const LOCK_DATA_FIELD = enum__LOCK_DATA_FIELD;
pub const RECOMMISSION_DISABLE_PERMALOCK: c_int = 1;
pub const RECOMMISSION_DISABLE_USER_MEMORY: c_int = 2;
pub const RECOMMISSION_DISABLE_USER_MEMORY_2ND_OPTION: c_int = 3;
pub const RECOMMISSION_DISABLE_PASSWORD: c_int = 4;
pub const RECOMMISSION_DISABLE_PERMALOCK_PASSWORD: c_int = 5;
pub const RECOMMISSION_DISABLE_USER_MEMORY_PASSWORD: c_int = 6;
pub const RECOMMISSION_DISABLE_USER_MEMORY_PASSWORD_2ND_OPTION: c_int = 7;
pub const enum__RECOMMISSION_OPERATION_CODE = c_uint;
pub const RECOMMISSION_OPERATION_CODE = enum__RECOMMISSION_OPERATION_CODE;
pub const TID_HIDE_NONE: c_int = 0;
pub const TID_HIDE_SOME: c_int = 1;
pub const TID_HIDE_ALL: c_int = 2;
pub const enum__TID_HIDE_STATE = c_uint;
pub const TID_HIDE_STATE = enum__TID_HIDE_STATE;
pub const RANGE_NORMAL: c_int = 0;
pub const RANGE_TOGGLE: c_int = 1;
pub const RANGE_REDUCED: c_int = 2;
pub const enum__TAG_OPERATING_RANGE = c_uint;
pub const TAG_OPERATING_RANGE = enum__TAG_OPERATING_RANGE;
pub const ANTENNA_MODE_BISTATIC: c_int = 0;
pub const ANTENNA_MODE_MONOSTATIC: c_int = 1;
pub const enum__ANTENNA_MODE = c_uint;
pub const ANTENNA_MODE = enum__ANTENNA_MODE;
pub const ACCESS_OPERATION_READ: c_int = 0;
pub const ACCESS_OPERATION_WRITE: c_int = 1;
pub const ACCESS_OPERATION_LOCK: c_int = 2;
pub const ACCESS_OPERATION_KILL: c_int = 3;
pub const ACCESS_OPERATION_BLOCK_WRITE: c_int = 4;
pub const ACCESS_OPERATION_BLOCK_ERASE: c_int = 5;
pub const ACCESS_OPERATION_RECOMMISSION: c_int = 6;
pub const ACCESS_OPERATION_BLOCK_PERMALOCK: c_int = 7;
pub const ACCESS_OPERATION_NXP_SET_EAS: c_int = 8;
pub const ACCESS_OPERATION_NXP_READ_PROTECT: c_int = 9;
pub const ACCESS_OPERATION_NXP_RESET_READ_PROTECT: c_int = 10;
pub const ACCESS_OPERATION_FUJITSU_CHANGE_WORDLOCK: c_int = 11;
pub const ACCESS_OPERATION_FUJITSU_CHANGE_BLOCKLOCK: c_int = 12;
pub const ACCESS_OPERATION_FUJITSU_READ_BLOCKLOCK: c_int = 13;
pub const ACCESS_OPERATION_FUJITSU_BURST_WRITE: c_int = 14;
pub const ACCESS_OPERATION_FUJITSU_BURST_ERASE: c_int = 15;
pub const ACCESS_OPERATION_FUJITSU_CHANGE_BLOCK_OR_AREA_GROUPPASSWORD: c_int = 16;
pub const ACCESS_OPERATION_FUJITSU_AREA_READLOCK: c_int = 17;
pub const ACCESS_OPERATION_FUJITSU_AREA_WRITELOCK: c_int = 18;
pub const ACCESS_OPERATION_FUJITSU_AREA_WRITELOCK_WOPASSWORD: c_int = 19;
pub const ACCESS_OPERATION_IMPINJ_QT_WRITE: c_int = 20;
pub const ACCESS_OPERATION_IMPINJ_QT_READ: c_int = 21;
pub const ACCESS_OPERATION_NXP_CHANGE_CONFIG: c_int = 22;
pub const ACCESS_OPERATION_AUTHENTICATE: c_int = 23;
pub const ACCESS_OPERATION_READBUFFER: c_int = 24;
pub const ACCESS_OPERATION_UNTRACEABLE: c_int = 25;
pub const ACCESS_OPERATION_CRYPTO: c_int = 26;
pub const ACCESS_OPERATION_NONE: c_int = 255;
pub const enum__ACCESS_OPERATION_CODE = c_uint;
pub const ACCESS_OPERATION_CODE = enum__ACCESS_OPERATION_CODE;
pub const ANTENNA_ID: c_int = 1;
pub const FIRST_SEEN_TIME_STAMP: c_int = 2;
pub const LAST_SEEN_TIME_STAMP: c_int = 4;
pub const PEAK_RSSI: c_int = 8;
pub const TAG_SEEN_COUNT: c_int = 16;
pub const PC: c_int = 32;
pub const XPC: c_int = 64;
pub const CRC: c_int = 128;
pub const CHANNEL_INDEX: c_int = 256;
pub const PHYSICAL_PORT: c_int = 512;
pub const ZONE_ID: c_int = 1024;
pub const ZONE_NAME: c_int = 2048;
pub const PHASE_INFO: c_int = 4096;
pub const BRAND_CHECK_STATUS: c_int = 8192;
pub const GPS_COORDINATES: c_int = 16384;
pub const ALL_TAG_FIELDS: c_int = 32767;
pub const enum__TAG_FIELD = c_uint;
pub const TAG_FIELD = enum__TAG_FIELD;
pub const RFSURVEY_ANTENNA_ID: c_int = 1;
pub const TIME_STAMP: c_int = 2;
pub const AVERAGE_RSSI: c_int = 4;
pub const RFSURVEY_PEAK_RSSI: c_int = 8;
pub const BANDWIDTH: c_int = 16;
pub const FREQUENCY: c_int = 32;
pub const ALL_RFSURVEY_FIELDS: c_int = 64;
pub const enum__RFSURVEY_FIELD = c_uint;
pub const RFSURVEY_FIELD = enum__RFSURVEY_FIELD;
pub const UNKNOWN_STATE: c_int = 0;
pub const NEW_TAG_VISIBLE: c_int = 1;
pub const TAG_NOT_VISIBLE: c_int = 2;
pub const TAG_BACK_TO_VISIBILITY: c_int = 3;
pub const TAG_MOVING: c_int = 4;
pub const TAG_STATIONARY: c_int = 5;
pub const NONE: c_int = 6;
pub const enum__TAG_EVENT = c_uint;
pub const TAG_EVENT = enum__TAG_EVENT;
pub const NEVER: c_int = 0;
pub const IMMEDIATE: c_int = 1;
pub const MODERATED: c_int = 2;
pub const enum__TAG_EVENT_REPORT_TRIGGER = c_uint;
pub const TAG_EVENT_REPORT_TRIGGER = enum__TAG_EVENT_REPORT_TRIGGER;
pub const TAG_MOVING_EVENT_DISABLE: c_int = 0;
pub const TAG_MOVING_EVENT_ENABLE: c_int = 1;
pub const enum__TAG_MOVING_EVENT_REPORT = c_uint;
pub const TAG_MOVING_EVENT_REPORT = enum__TAG_MOVING_EVENT_REPORT;
pub const XR: c_int = 0;
pub const FX: c_int = 1;
pub const MC: c_int = 2;
pub const enum__READER_TYPE = c_uint;
pub const READER_TYPE = enum__READER_TYPE;
pub const A_AND_B: c_int = 0;
pub const NOTA_AND_B: c_int = 1;
pub const NOTA_AND_NOTB: c_int = 2;
pub const A_AND_NOTB: c_int = 3;
pub const enum__MATCH_PATTERN = c_uint;
pub const MATCH_PATTERN = enum__MATCH_PATTERN;
pub const WITHIN_RANGE: c_int = 0;
pub const OUTSIDE_RANGE: c_int = 1;
pub const GREATER_THAN_LOWER_LIMIT: c_int = 2;
pub const LOWER_THAN_UPPER_LIMIT: c_int = 3;
pub const enum__MATCH_RANGE = c_uint;
pub const MATCH_RANGE = enum__MATCH_RANGE;
pub const INCLUSIVE_TAG_LIST: c_int = 0;
pub const EXCLUSIVE_TAG_LIST: c_int = 1;
pub const enum__MATCH_TAG_LIST = c_uint;
pub const MATCH_TAG_LIST = enum__MATCH_TAG_LIST;
pub const TRACE_LEVEL_OFF: c_int = 0;
pub const TRACE_LEVEL_FATAL: c_int = 1;
pub const TRACE_LEVEL_ERROR: c_int = 2;
pub const TRACE_LEVEL_WARNING: c_int = 4;
pub const TRACE_LEVEL_INFO: c_int = 8;
pub const TRACE_LEVEL_VERBOSE: c_int = 16;
pub const TRACE_LEVEL_ALL: c_int = 31;
pub const enum__TRACE_LEVEL = c_uint;
pub const TRACE_LEVEL = enum__TRACE_LEVEL;
pub const MAC_LENGTH: c_int = 8;
pub const EPC_LENGTH: c_int = 12;
pub const enum__READER_ID_LENGTH = c_uint;
pub const READER_ID_LENGTH = enum__READER_ID_LENGTH;
pub const RM: c_int = 0;
pub const LLRP_SERVER: c_int = 1;
pub const enum__SERVICE_ID = c_uint;
pub const SERVICE_ID = enum__SERVICE_ID;
pub const DOWN: c_int = 0;
pub const UP: c_int = 1;
pub const enum__HEALTH_STATUS = c_uint;
pub const HEALTH_STATUS = enum__HEALTH_STATUS;
pub const ACTIVE_SYNC: c_int = 0;
pub const NETWORK: c_int = 1;
pub const enum__USB_OPERATION_MODE = c_uint;
pub const USB_OPERATION_MODE = enum__USB_OPERATION_MODE;
pub const FULL: c_int = 0;
pub const POE_PLUS: c_int = 1;
pub const POE: c_int = 2;
pub const enum__POWER_SOURCE_TYPE = c_uint;
pub const POWER_SOURCE_TYPE = enum__POWER_SOURCE_TYPE;
pub const DISABLED_STATE: c_int = 0;
pub const ONGOING: c_int = 1;
pub const SUCCEEDED: c_int = 2;
pub const FAILURE: c_int = 3;
pub const NOT_APPLICABLE: c_int = 4;
pub const enum__POWER_NEGOTIATION_STATUS = c_uint;
pub const POWER_NEGOTIATION_STATUS = enum__POWER_NEGOTIATION_STATUS;
pub const LED_OFF: c_int = 0;
pub const LED_RED: c_int = 1;
pub const LED_GREEN: c_int = 2;
pub const LED_YELLOW: c_int = 3;
pub const enum__LED_COLOR = c_uint;
pub const LED_COLOR = enum__LED_COLOR;
pub const C1G2_OPERATION: c_int = 0;
pub const NXP_EAS_SCAN: c_int = 1;
pub const LOCATE_TAG: c_int = 2;
pub const enum__OPERATION_QUALIFIER = c_uint;
pub const OPERATION_QUALIFIER = enum__OPERATION_QUALIFIER;
pub const AMBIENT: c_int = 0;
pub const PA: c_int = 1;
pub const enum__TEMPERATURE_SOURCE = c_uint;
pub const TEMPERATURE_SOURCE = enum__TEMPERATURE_SOURCE;
pub const LOW: c_int = 0;
pub const HIGH: c_int = 1;
pub const CRITICAL: c_int = 2;
pub const enum__ALARM_LEVEL = c_uint;
pub const ALARM_LEVEL = enum__ALARM_LEVEL;
pub const ANTENNA_STOP_TRIGGER_TYPE_N_ATTEMPTS: c_int = 1;
pub const ANTENNA_STOP_TRIGGER_TYPE_DURATION_MILLISECS: c_int = 2;
pub const ANTENNA_STOP_TRIGGER_TYPE_DURATION_SECS: c_int = 3;
pub const ANTENNA_STOP_TRIGGER_TYPE_DURATION_MILLISECS_ONE_ROUND: c_int = 4;
pub const enum__ANTENNA_STOP_TRIGGER_TYPE = c_uint;
pub const ANTENNA_STOP_TRIGGER_TYPE = enum__ANTENNA_STOP_TRIGGER_TYPE;
pub const BATTERY_CHARGING: c_int = 0;
pub const BATTERY_DISCHARGING: c_int = 1;
pub const BATTERY_LEVEL_CRITICAL: c_int = 2;
pub const BATTERY_STATUS_UNKNOWN: c_int = -1;
pub const enum__BATTERY_STATUS = c_int;
pub const BATTERY_STATUS = enum__BATTERY_STATUS;
pub const RADIO_TRANSMIT_DELAY_OFF: c_int = 0;
pub const RADIO_TRANSMIT_DELAY_ON_NO_TAG: c_int = 1;
pub const RADIO_TRANSMIT_DELAY_ON_NO_UNIQUE_TAG: c_int = 2;
pub const enum__RADIO_TRANSMIT_DELAY_TYPE = c_uint;
pub const RADIO_TRANSMIT_DELAY_TYPE = enum__RADIO_TRANSMIT_DELAY_TYPE;
pub const ALGORITHM_PARAMS: c_int = 0;
pub const PERFORM_VSWR_TEST: c_int = 1;
pub const STOP_VSWR_TEST: c_int = 2;
pub const READER_DIAGNOSTICS_CONFIGURATION: c_int = 3;
pub const RFID_PARAM_MAX: c_int = 4;
pub const enum__RFID_PARAM_TYPE = c_uint;
pub const RFID_PARAM_TYPE = enum__RFID_PARAM_TYPE;
pub const SMART_NONE: c_int = 0;
pub const SMART_SELECT: c_int = 1;
pub const SMART_MLT: c_int = 2;
pub const SMART_SELECT_MLT: c_int = 3;
pub const enum__SMART_ALGORITHM_SELECTOR = c_uint;
pub const SMART_ALGORITHM_SELECTOR = enum__SMART_ALGORITHM_SELECTOR;
pub const MLT_TAG_MOVING: c_int = 0;
pub const MLT_TAG_STATIC: c_int = 1;
pub const MLT_TAG_LOST: c_int = 2;
pub const enum__MLT_TAG_STATE = c_uint;
pub const MLT_TAG_STATE = enum__MLT_TAG_STATE;
pub const MLT_IOR_READER: c_int = 0;
pub const MLT_TRANSITION_READER: c_int = 1;
pub const MLT_STAR_READER: c_int = 2;
pub const MLT_CONTACT_READER: c_int = 3;
pub const enum__MLT_READER_TYPE = c_uint;
pub const MLT_READER_TYPE = enum__MLT_READER_TYPE;
pub const RFID_API_SUCCESS: c_int = 0;
pub const RFID_API_COMMAND_TIMEOUT: c_int = 1;
pub const RFID_API_PARAM_ERROR: c_int = 2;
pub const RFID_API_PARAM_OUT_OF_RANGE: c_int = 3;
pub const RFID_API_CANNOT_ALLOC_MEM: c_int = 4;
pub const RFID_API_UNKNOWN_ERROR: c_int = 5;
pub const RFID_API_INVALID_HANDLE: c_int = 6;
pub const RFID_API_BUFFER_TOO_SMALL: c_int = 7;
pub const RFID_READER_FUNCTION_UNSUPPORTED: c_int = 8;
pub const RFID_RECONNECT_FAILED: c_int = 9;
pub const RFID_API_DATA_NOT_INITIALISED: c_int = 10;
pub const RFID_API_ZONE_ID_ALREADY_EXITS: c_int = 11;
pub const RFID_API_ZONE_ID_NOT_FOUND: c_int = 12;
pub const RFID_COMM_OPEN_ERROR: c_int = 100;
pub const RFID_COMM_CONNECTION_ALREADY_EXISTS: c_int = 101;
pub const RFID_COMM_RESOLVE_ERROR: c_int = 102;
pub const RFID_COMM_SEND_ERROR: c_int = 103;
pub const RFID_COMM_RECV_ERROR: c_int = 104;
pub const RFID_COMM_NO_CONNECTION: c_int = 105;
pub const RFID_INVALID_SOCKET: c_int = 106;
pub const RFID_READER_REGION_NOT_CONFIGURED: c_int = 107;
pub const RFID_READER_REINITIALIZING: c_int = 108;
pub const RFID_SECURE_CONNECTION_ERROR: c_int = 109;
pub const RFID_ROOT_SECURITY_CERTIFICATE_ERROR: c_int = 110;
pub const RFID_HOST_SECURITY_CERTIFICATE_ERROR: c_int = 111;
pub const RFID_HOST_SECURITY_KEY_ERROR: c_int = 112;
pub const RFID_CONFIG_GET_FAILED: c_int = 200;
pub const RFID_CONFIG_SET_FAILED: c_int = 201;
pub const RFID_CONFIG_NOT_SUPPORTED: c_int = 202;
pub const RFID_CAP_NOT_SUPPORTED: c_int = 300;
pub const RFID_CAP_GET_FAILED: c_int = 301;
pub const RFID_FILTER_NO_FILTER: c_int = 400;
pub const RFID_FILTER_INVALID_INDEX: c_int = 401;
pub const RFID_FILTER_MAX_FILTERS_EXCEEDED: c_int = 402;
pub const RFID_NO_READ_TAGS: c_int = 403;
pub const RFID_NO_REPORTED_EVENTS: c_int = 404;
pub const RFID_INVENTORY_MAX_TAGS_EXCEEDED: c_int = 405;
pub const RFID_INVENTORY_IN_PROGRESS: c_int = 406;
pub const RFID_NO_INVENTORY_IN_PROGRESS: c_int = 407;
pub const RFID_TAG_LOCATING_IN_PROGRESS: c_int = 420;
pub const RFID_NO_TAG_LOCATING_IN_PROGRESS: c_int = 421;
pub const RFID_NXP_EAS_SCAN_IN_PROGRESS: c_int = 422;
pub const RFID_NO_NXP_EAS_SCAN_IN_PROGRESS: c_int = 423;
pub const RFID_ACCESS_IN_PROGRESS: c_int = 500;
pub const RFID_NO_ACCESS_IN_PROGRESS: c_int = 501;
pub const RFID_ACCESS_TAG_READ_FAILED: c_int = 502;
pub const RFID_ACCESS_TAG_WRITE_FAILED: c_int = 503;
pub const RFID_ACCESS_TAG_LOCK_FAILED: c_int = 504;
pub const RFID_ACCESS_TAG_KILL_FAILED: c_int = 505;
pub const RFID_ACCESS_TAG_BLOCK_ERASE_FAILED: c_int = 506;
pub const RFID_ACCESS_TAG_BLOCK_WRITE_FAILED: c_int = 507;
pub const RFID_ACCESS_TAG_NOT_FOUND: c_int = 508;
pub const RFID_ACCESS_SEQUENCE_NOT_INITIALIZED: c_int = 510;
pub const RFID_ACCESS_SEQUENCE_EMPTY: c_int = 511;
pub const RFID_ACCESS_SEQUENCE_IN_USE: c_int = 512;
pub const RFID_ACCESS_SEQUENCE_MAX_OP_EXCEEDED: c_int = 513;
pub const RFID_ACCESS_TAG_RECOMMISSION_FAILED: c_int = 514;
pub const RFID_ACCESS_TAG_BLOCK_PERMALOCK_FAILED: c_int = 515;
pub const RFID_ACCESS_NXP_TAG_SET_EAS_FAILED: c_int = 516;
pub const RFID_ACCESS_NXP_TAG_READ_PROTECT_FAILED: c_int = 517;
pub const RFID_ACCESS_FUJITSU_CHANGE_WORDLOCK_FAILED: c_int = 518;
pub const RFID_ACCESS_FUJITSU_CHANGE_BLOCKLOCK_FAILED: c_int = 519;
pub const RFID_ACCESS_FUJITSU_READ_BLOCKLOCK_FAILED: c_int = 520;
pub const RFID_ACCESS_FUJITSU_BURST_WRITE_FAILED: c_int = 521;
pub const RFID_ACCESS_FUJITSU_BURST_ERASE_FAILED: c_int = 522;
pub const RFID_ACCESS_FUJITSU_CHANGE_BLOCK_OR_AREA_GROUPPASSWORD_FAILED: c_int = 523;
pub const RFID_ACCESS_FUJITSU_AREA_READLOCK_FAILED: c_int = 524;
pub const RFID_ACCESS_FUJITSU_AREA_WRITELOCK_FAILED: c_int = 525;
pub const RFID_ACCESS_FUJITSU_AREA_WRITELOCK_WOPASSWORD_FAILED: c_int = 526;
pub const RFID_ACCESS_NXP_CHANGE_CONFIG_FAILED: c_int = 527;
pub const RFID_ACCESS_IMPINJ_QT_READ_FAILED: c_int = 528;
pub const RFID_ACCESS_IMPINJ_QT_WRITE_FAILED: c_int = 529;
pub const RFID_ACCESS_G2V2_AUTHENTICATE_FAILED: c_int = 530;
pub const RFID_ACCESS_G2V2_READBUFFER_FAILED: c_int = 531;
pub const RFID_ACCESS_G2V2_UNTRACEABLE_FAILED: c_int = 532;
pub const RFID_ACCESS_G2V2_CRYPTO_FAILED: c_int = 533;
pub const RFID_RM_INVALID_USERNAME_PASSWORD: c_int = 601;
pub const RFID_RM_NO_UPDATION_IN_PROGRESS: c_int = 602;
pub const RFID_RM_UPDATION_IN_PROGRESS: c_int = 603;
pub const RFID_RM_COMMAND_FAILED: c_int = 604;
pub const RFID_NXP_BRANDID_CHECK_IN_PROGRESS: c_int = 605;
pub const RFID_NO_RF_SURVEY_OPERATION_IN_PROGRESS: c_int = 606;
pub const RFID_RFSURVEY_IN_PROGRESS: c_int = 607;
pub const RFID_INVALID_ERROR_CODE: c_int = 700;
pub const enum__RFID_STATUS = c_uint;
pub const RFID_STATUS = enum__RFID_STATUS;
pub const ACCESS_SUCCESS: c_int = 0;
pub const ACCESS_TAG_NON_SPECIFIC_ERROR: c_int = 1;
pub const ACCESS_READER_NON_SPECIFIC_ERROR: c_int = 2;
pub const ACCESS_NO_RESPONSE_FROM_TAG: c_int = 3;
pub const ACCESS_INSUFFIFICENT_POWER: c_int = 4;
pub const ACCESS_INSUFFICENT_POWER: c_int = 4;
pub const ACCESS_TAG_MEMORY_LOCKED_ERROR: c_int = 5;
pub const ACCESS_TAG_MEMORY_OVERRUN_ERROR: c_int = 6;
pub const ACCESS_ZERO_KILL_PASSWORD_ERROR: c_int = 7;
pub const ACCESS_TAG_IN_PROCESS_STILL_WORKING: c_int = 8;
pub const ACCESS_TAG_SUCCESS_STORED_RESPONSE_WITHOUT_LENGTH: c_int = 9;
pub const ACCESS_TAG_SUCCESS_STORED_RESPONSE_WITH_LENGTH: c_int = 10;
pub const ACCESS_TAG_SUCCESS_SEND_RESPONSE_WITHOUT_LENGTH: c_int = 11;
pub const ACCESS_TAG_SUCCESS_SEND_RESPONSE_WITH_LENGTH: c_int = 12;
pub const ACCESS_TAG_ERROR_STORED_RESPONSE_WITHOUT_LENGTH: c_int = 13;
pub const ACCESS_TAG_ERROR_STORED_RESPONSE_WITH_LENGTH: c_int = 14;
pub const ACCESS_TAG_ERROR_SEND_RESPONSE_WITHOUT_LENGTH: c_int = 15;
pub const ACCESS_TAG_ERROR_SEND_RESPONSE_WITH_LENGTH: c_int = 16;
pub const enum__ACCESS_OPERATION_STATUS = c_uint;
pub const ACCESS_OPERATION_STATUS = enum__ACCESS_OPERATION_STATUS;
pub const struct__SEC_CONNECTION_INFO = extern struct {
    secureMode: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    validatePeerCert: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    sizeCertBuff: UINT32 = @import("std").mem.zeroes(UINT32),
    clientCertBuff: [*c]BYTE = @import("std").mem.zeroes([*c]BYTE),
    sizeKeyBuff: UINT32 = @import("std").mem.zeroes(UINT32),
    clientKeyBuff: [*c]BYTE = @import("std").mem.zeroes([*c]BYTE),
    sizePhraseBuff: UINT32 = @import("std").mem.zeroes(UINT32),
    phraseBuff: [*c]BYTE = @import("std").mem.zeroes([*c]BYTE),
    sizeRootCertBuff: UINT32 = @import("std").mem.zeroes(UINT32),
    rootCertBuff: [*c]BYTE = @import("std").mem.zeroes([*c]BYTE),
    connStatus: ULONG = @import("std").mem.zeroes(ULONG),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const SEC_CONNECTION_INFO = struct__SEC_CONNECTION_INFO;
pub const PSEC_CONNECTION_INFO = [*c]struct__SEC_CONNECTION_INFO;
pub const struct__CONNECTION_INFO = extern struct {
    version: RFID_VERSION = @import("std").mem.zeroes(RFID_VERSION),
    lpSecConInfo: PSEC_CONNECTION_INFO = @import("std").mem.zeroes(PSEC_CONNECTION_INFO),
    lpReserved: [3]LPVOID = @import("std").mem.zeroes([3]LPVOID),
};
pub const CONNECTION_INFO = struct__CONNECTION_INFO;
pub const LPCONNECTION_INFO = [*c]struct__CONNECTION_INFO;
pub const struct__SERVER_INFO = extern struct {
    timeoutMilliseconds: UINT32 = @import("std").mem.zeroes(UINT32),
    version: RFID_VERSION = @import("std").mem.zeroes(RFID_VERSION),
    lpSecConInfo: PSEC_CONNECTION_INFO = @import("std").mem.zeroes(PSEC_CONNECTION_INFO),
    lpReserved: [3]LPVOID = @import("std").mem.zeroes([3]LPVOID),
};
pub const SERVER_INFO = struct__SERVER_INFO;
pub const LPSERVER_INFO = [*c]struct__SERVER_INFO;
pub const struct__ANTENNA_INFO = extern struct {
    pAntennaList: [*c]UINT16 = @import("std").mem.zeroes([*c]UINT16),
    length: UINT32 = @import("std").mem.zeroes(UINT32),
    pAntennaOpList: [*c]OPERATION_QUALIFIER = @import("std").mem.zeroes([*c]OPERATION_QUALIFIER),
    lpReserved: [3]LPVOID = @import("std").mem.zeroes([3]LPVOID),
};
pub const ANTENNA_INFO = struct__ANTENNA_INFO;
pub const LPANTENNA_INFO = [*c]struct__ANTENNA_INFO;
const union_unnamed_4 = extern union {
    relativeDistance: INT16,
    lpReserved: [16]LPVOID,
};
pub const struct__LOCATION_INFO = extern struct {
    unnamed_0: union_unnamed_4 = @import("std").mem.zeroes(union_unnamed_4),
    lpReserved1: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const LOCATION_INFO = struct__LOCATION_INFO;
pub const LPLOCATION_INFO = [*c]struct__LOCATION_INFO;
pub const struct__GPS_LOCATION = extern struct {
    longitude: INT32 = @import("std").mem.zeroes(INT32),
    latitude: INT32 = @import("std").mem.zeroes(INT32),
    altitude: INT32 = @import("std").mem.zeroes(INT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const GPS_LOCATION = struct__GPS_LOCATION;
pub const LPGPS_LOCATION = [*c]struct__GPS_LOCATION;
pub const struct__MLT_LOCATION_REPORT = extern struct {
    XCoordEstimate: UINT32 = @import("std").mem.zeroes(UINT32),
    YCoordEstimate: UINT32 = @import("std").mem.zeroes(UINT32),
    ZCoordEstimate: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const MLT_LOCATION_REPORT = struct__MLT_LOCATION_REPORT;
pub const LPMLT_LOCATION_REPORT = [*c]struct__MLT_LOCATION_REPORT;
pub const struct__MLT_TAG_READ_REPORT = extern struct {
    ReadsDuringTriggerWindow: UINT32 = @import("std").mem.zeroes(UINT32),
    ReadTimeStamp: SYSTEMTIME = @import("std").mem.zeroes(SYSTEMTIME),
    Confidence: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [3]LPVOID = @import("std").mem.zeroes([3]LPVOID),
};
pub const MLT_TAG_READ_REPORT = struct__MLT_TAG_READ_REPORT;
pub const LPMLT_TAG_READ_REPORT = [*c]struct__MLT_TAG_READ_REPORT;
pub const struct__MLT_TRANSITION_REPORT = extern struct {
    TransitionDirectionEstimate: INT32 = @import("std").mem.zeroes(INT32),
    MovingFlag: MLT_TAG_STATE = @import("std").mem.zeroes(MLT_TAG_STATE),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const MLT_TRANSITION_REPORT = struct__MLT_TRANSITION_REPORT;
pub const LPMLT_TRANSITION_REPORT = [*c]struct__MLT_TRANSITION_REPORT;
pub const struct__MLT_READER_PARAMSW = extern struct {
    readerType: MLT_READER_TYPE = @import("std").mem.zeroes(MLT_READER_TYPE),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const MLT_READER_PARAMSW = struct__MLT_READER_PARAMSW;
pub const LPMLT_READER_PARAMSW = [*c]struct__MLT_READER_PARAMSW;
pub const struct__MLT_READER_PARAMSA = extern struct {
    readerType: MLT_READER_TYPE = @import("std").mem.zeroes(MLT_READER_TYPE),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const MLT_READER_PARAMSA = struct__MLT_READER_PARAMSA;
pub const LPMLT_READER_PARAMSA = [*c]struct__MLT_READER_PARAMSA;
pub const MLT_READER_PARAMS = MLT_READER_PARAMSA;
pub const LPMLT_READER_PARAMS = LPMLT_READER_PARAMSA;
pub const struct__MLT_ALGORITHM_REPORT = extern struct {
    MLTLocationReport: MLT_LOCATION_REPORT = @import("std").mem.zeroes(MLT_LOCATION_REPORT),
    MLTTagReadReport: MLT_TAG_READ_REPORT = @import("std").mem.zeroes(MLT_TAG_READ_REPORT),
    MLTTransistionReport: MLT_TRANSITION_REPORT = @import("std").mem.zeroes(MLT_TRANSITION_REPORT),
    MLTReaderParams: MLT_READER_PARAMS = @import("std").mem.zeroes(MLT_READER_PARAMS),
    lpReserved: [5]LPVOID = @import("std").mem.zeroes([5]LPVOID),
};
pub const MLT_ALGORITHM_REPORT = struct__MLT_ALGORITHM_REPORT;
pub const LPMLT_ALGORITHM_REPORT = [*c]struct__MLT_ALGORITHM_REPORT;
pub const struct__MLT_TIMEWINDOWSIZE_PARAMS = extern struct {
    LocationTime: UINT32 = @import("std").mem.zeroes(UINT32),
    MotionTime: UINT32 = @import("std").mem.zeroes(UINT32),
    TransitionTime: UINT32 = @import("std").mem.zeroes(UINT32),
    BucketSize: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const MLT_TIMEWINDOWSIZE_PARAMS = struct__MLT_TIMEWINDOWSIZE_PARAMS;
pub const LPMLT_TIMEWINDOWSIZE_PARAMS = [*c]struct__MLT_TIMEWINDOWSIZE_PARAMS;
pub const struct__MLT_TIMELIMIT_PARAMS = extern struct {
    MotionDelay: UINT32 = @import("std").mem.zeroes(UINT32),
    LostEventDelay: UINT32 = @import("std").mem.zeroes(UINT32),
    ReportUpdate: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const MLT_TIMELIMIT_PARAMS = struct__MLT_TIMELIMIT_PARAMS;
pub const LPMLT_TIMELIMIT_PARAMS = [*c]struct__MLT_TIMELIMIT_PARAMS;
pub const struct__MLT_ANTENNA_MAP_TABLE = extern struct {
    AntennaId: UINT32 = @import("std").mem.zeroes(UINT32),
    pseudoX: INT32 = @import("std").mem.zeroes(INT32),
    pseudoY: INT32 = @import("std").mem.zeroes(INT32),
    pseudoZ: INT32 = @import("std").mem.zeroes(INT32),
    GroupId: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const MLT_ANTENNA_MAP_TABLE = struct__MLT_ANTENNA_MAP_TABLE;
pub const LPMLT_ANTENNA_MAP_TABLE = [*c]struct__MLT_ANTENNA_MAP_TABLE;
pub const struct__MLT_TRANSITION_SLOPETABLE = extern struct {
    Direction: INT32 = @import("std").mem.zeroes(INT32),
    Slope: INT32 = @import("std").mem.zeroes(INT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const MLT_TRANSITION_SLOPETABLE = struct__MLT_TRANSITION_SLOPETABLE;
pub const LPMLT_TRANSITION_SLOPETABLE = [*c]struct__MLT_TRANSITION_SLOPETABLE;
pub const struct__MLT_ALGORITHM_PARAMS = extern struct {
    TimeWindowSizeParams: MLT_TIMEWINDOWSIZE_PARAMS = @import("std").mem.zeroes(MLT_TIMEWINDOWSIZE_PARAMS),
    TimeLimitParams: MLT_TIMELIMIT_PARAMS = @import("std").mem.zeroes(MLT_TIMELIMIT_PARAMS),
    ReaderType: MLT_READER_PARAMS = @import("std").mem.zeroes(MLT_READER_PARAMS),
    AntennaMapTable: [8]MLT_ANTENNA_MAP_TABLE = @import("std").mem.zeroes([8]MLT_ANTENNA_MAP_TABLE),
    TransitionSlopeTable: [4]MLT_TRANSITION_SLOPETABLE = @import("std").mem.zeroes([4]MLT_TRANSITION_SLOPETABLE),
    lpReserved: [5]LPVOID = @import("std").mem.zeroes([5]LPVOID),
};
pub const MLT_ALGORITHM_PARAMS = struct__MLT_ALGORITHM_PARAMS;
pub const LPMLT_ALGORITHM_PARAMS = [*c]struct__MLT_ALGORITHM_PARAMS;
pub const struct__IMPINJ_QT_DATA = extern struct {
    QTControlData: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const IMPINJ_QT_DATA = struct__IMPINJ_QT_DATA;
pub const LPIMPINJ_QT_DATA = [*c]struct__IMPINJ_QT_DATA;
pub const struct__IMPINJ_QT_WRITE_PARAMS = extern struct {
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    QTPersist: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    qtdata: IMPINJ_QT_DATA = @import("std").mem.zeroes(IMPINJ_QT_DATA),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const IMPINJ_QT_WRITE_PARAMS = struct__IMPINJ_QT_WRITE_PARAMS;
pub const LPIMPINJ_QT_WRITE_PARAMS = [*c]struct__IMPINJ_QT_WRITE_PARAMS;
pub const struct__IMPINJ_QT_READ_PARMS = extern struct {
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const IMPINJ_QT_READ_PARMS = struct__IMPINJ_QT_READ_PARMS;
pub const LPIMPINJ_QT_READ_PARMS = [*c]struct__IMPINJ_QT_READ_PARMS;
pub const struct__NXP_CHANGE_CONFIG_PARAMS = extern struct {
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    NXPChangeConfigWord: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const NXP_CHANGE_CONFIG_PARAMS = struct__NXP_CHANGE_CONFIG_PARAMS;
pub const LPNXP_CHANGE_CONFIG_PARAMS = [*c]struct__NXP_CHANGE_CONFIG_PARAMS;
const struct_unnamed_6 = extern struct {
    blockLockStatus: UINT16 = @import("std").mem.zeroes(UINT16),
};
const struct_unnamed_7 = extern struct {
    numberOfBytesNotWritten: UINT8 = @import("std").mem.zeroes(UINT8),
};
const struct_unnamed_8 = extern struct {
    numberOfBytesNotErased: UINT8 = @import("std").mem.zeroes(UINT8),
};
const struct_unnamed_9 = extern struct {
    ChangeConfigWord: UINT16 = @import("std").mem.zeroes(UINT16),
};
const struct_unnamed_10 = extern struct {
    receivedBitCount: UINT16 = @import("std").mem.zeroes(UINT16),
    pReceivedBitData: [*c]UINT8 = @import("std").mem.zeroes([*c]UINT8),
};
const union_unnamed_5 = extern union {
    FujitsuReadBlockLockResult: struct_unnamed_6,
    FujitsuBurstWriteResult: struct_unnamed_7,
    FujitsuBurstEraseResult: struct_unnamed_8,
    QtData: IMPINJ_QT_DATA,
    NXPChangeConfigWordResult: struct_unnamed_9,
    AuthenticateReadBufferResult: struct_unnamed_10,
    lpReserved1: [16]LPVOID,
};
pub const struct__ACCESS_OPERATION_RESULT = extern struct {
    unnamed_0: union_unnamed_5 = @import("std").mem.zeroes(union_unnamed_5),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const ACCESS_OPERATION_RESULT = struct__ACCESS_OPERATION_RESULT;
pub const LPACCESS_OPERATION_RESULT = [*c]struct__ACCESS_OPERATION_RESULT;
pub const _STRUCT_INFO = extern struct {
    memoryAllocated: UINT32 = @import("std").mem.zeroes(UINT32),
    memoryUsed: UINT32 = @import("std").mem.zeroes(UINT32),
};
pub const struct__STATE_AWARE_SINGULATION_ACTION = extern struct {
    perform: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    inventoryState: INVENTORY_STATE = @import("std").mem.zeroes(INVENTORY_STATE),
    slFlag: SL_FLAG = @import("std").mem.zeroes(SL_FLAG),
};
pub const STATE_AWARE_SINGULATION_ACTION = struct__STATE_AWARE_SINGULATION_ACTION;
pub const LPSTATE_AWARE_SINGULATION_ACTION = [*c]struct__STATE_AWARE_SINGULATION_ACTION;
pub const struct__SINGULATION_CONTROL = extern struct {
    session: SESSION = @import("std").mem.zeroes(SESSION),
    tagPopulation: UINT16 = @import("std").mem.zeroes(UINT16),
    tagTransitTimeMilliseconds: UINT16 = @import("std").mem.zeroes(UINT16),
    stateAwareSingulationAction: STATE_AWARE_SINGULATION_ACTION = @import("std").mem.zeroes(STATE_AWARE_SINGULATION_ACTION),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const SINGULATION_CONTROL = struct__SINGULATION_CONTROL;
pub const LPSINGULATION_CONTROL = [*c]struct__SINGULATION_CONTROL;
pub const struct__PERSISTENCE_CONFIG = extern struct {
    saveConfiguration: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    saveTagData: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    SaveTagEventData: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
};
pub const PERSISTENCE_CONFIG = struct__PERSISTENCE_CONFIG;
pub const LPPERSISTENCE_CONFIG = [*c]struct__PERSISTENCE_CONFIG;
pub const struct__RF_MODE_TABLE_ENTRY = extern struct {
    modeIdentifer: UINT32 = @import("std").mem.zeroes(UINT32),
    divideRatio: DIVIDE_RATIO = @import("std").mem.zeroes(DIVIDE_RATIO),
    bdrValue: UINT32 = @import("std").mem.zeroes(UINT32),
    modulation: MODULATION = @import("std").mem.zeroes(MODULATION),
    forwardLinkModulationType: FORWARD_LINK_MODULATION = @import("std").mem.zeroes(FORWARD_LINK_MODULATION),
    pieValue: UINT32 = @import("std").mem.zeroes(UINT32),
    minTariValue: UINT32 = @import("std").mem.zeroes(UINT32),
    maxTariValue: UINT32 = @import("std").mem.zeroes(UINT32),
    stepTariValue: UINT32 = @import("std").mem.zeroes(UINT32),
    spectralMaskIndicator: SPECTRAL_MASK_INDICATOR = @import("std").mem.zeroes(SPECTRAL_MASK_INDICATOR),
    epcHAGTCConformance: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const RF_MODE_TABLE_ENTRY = struct__RF_MODE_TABLE_ENTRY;
pub const LPRF_MODE_TABLE_ENTRY = [*c]struct__RF_MODE_TABLE_ENTRY;
pub const struct__UHF_RF_MODE_TABLE = extern struct {
    protocolID: UINT16 = @import("std").mem.zeroes(UINT16),
    numEntries: UINT16 = @import("std").mem.zeroes(UINT16),
    pTablesEntries: [*c]RF_MODE_TABLE_ENTRY = @import("std").mem.zeroes([*c]RF_MODE_TABLE_ENTRY),
};
pub const UHF_RF_MODE_TABLE = struct__UHF_RF_MODE_TABLE;
pub const LPUHF_RF_MODE_TABLE = [*c]struct__UHF_RF_MODE_TABLE;
pub const struct__RF_MODES = extern struct {
    numTables: UINT16 = @import("std").mem.zeroes(UINT16),
    pUHFTables: [*c]UHF_RF_MODE_TABLE = @import("std").mem.zeroes([*c]UHF_RF_MODE_TABLE),
};
pub const RF_MODES = struct__RF_MODES;
pub const LPRF_MODES = [*c]struct__RF_MODES;
pub const struct__TRANSMIT_POWER_LEVEL_TABLE = extern struct {
    numValues: UINT16 = @import("std").mem.zeroes(UINT16),
    pPowerValueList: [*c]UINT16 = @import("std").mem.zeroes([*c]UINT16),
};
pub const TRANSMIT_POWER_LEVEL_TABLE = struct__TRANSMIT_POWER_LEVEL_TABLE;
pub const LPTRANSMIT_POWER_LEVEL_TABLE = [*c]struct__TRANSMIT_POWER_LEVEL_TABLE;
pub const struct__RECEIVE_SENSITIVITY_TABLE = extern struct {
    numValues: UINT16 = @import("std").mem.zeroes(UINT16),
    pReceiveSensitivityValueList: [*c]UINT32 = @import("std").mem.zeroes([*c]UINT32),
};
pub const RECEIVE_SENSITIVITY_TABLE = struct__RECEIVE_SENSITIVITY_TABLE;
pub const LPRECEIVE_SENSITIVITY_TABLE = [*c]struct__RECEIVE_SENSITIVITY_TABLE;
pub const struct__DUTY_CYCLE_TABLE = extern struct {
    numValues: UINT16 = @import("std").mem.zeroes(UINT16),
    pDutyCycleValueList: [*c]UINT16 = @import("std").mem.zeroes([*c]UINT16),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const DUTY_CYCLE_TABLE = struct__DUTY_CYCLE_TABLE;
pub const LPDUTY_CYCLE_TABLE = [*c]struct__DUTY_CYCLE_TABLE;
pub const struct__FREQ_HOP_TABLE = extern struct {
    hopTableID: UINT16 = @import("std").mem.zeroes(UINT16),
    numFreq: UINT16 = @import("std").mem.zeroes(UINT16),
    pFreqList: [*c]UINT32 = @import("std").mem.zeroes([*c]UINT32),
};
pub const FREQ_HOP_TABLE = struct__FREQ_HOP_TABLE;
pub const LPFREQ_HOP_TABLE = [*c]struct__FREQ_HOP_TABLE;
pub const struct__FREQ_HOP_INFO = extern struct {
    numTables: UINT16 = @import("std").mem.zeroes(UINT16),
    pFreqTables: [*c]FREQ_HOP_TABLE = @import("std").mem.zeroes([*c]FREQ_HOP_TABLE),
};
pub const FREQ_HOP_INFO = struct__FREQ_HOP_INFO;
pub const LPFREQ_HOP_INFO = [*c]struct__FREQ_HOP_INFO;
pub const struct__FIXED_FREQ_INFO = extern struct {
    numFreq: UINT16 = @import("std").mem.zeroes(UINT16),
    pFreqList: [*c]UINT32 = @import("std").mem.zeroes([*c]UINT32),
};
pub const FIXED_FREQ_INFO = struct__FIXED_FREQ_INFO;
pub const LPFIXED_FREQ_INFO = [*c]struct__FIXED_FREQ_INFO;
pub const struct__PER_ANTENNA_RECEIVE_SENSITIVITY_RANGE = extern struct {
    lpReserved: [32]LPVOID = @import("std").mem.zeroes([32]LPVOID),
};
pub const PER_ANTENNA_RECEIVE_SENSITIVITY_RANGE = struct__PER_ANTENNA_RECEIVE_SENSITIVITY_RANGE;
pub const LPPER_ANTENNA_RECEIVE_SENSITIVITY_RANGE = [*c]struct__PER_ANTENNA_RECEIVE_SENSITIVITY_RANGE;
pub const struct__READER_IDW = extern struct {
    type: READER_ID_TYPE = @import("std").mem.zeroes(READER_ID_TYPE),
    value: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
};
pub const READER_IDW = struct__READER_IDW;
pub const LPREADER_IDW = [*c]struct__READER_IDW;
pub const struct__READER_IDA = extern struct {
    type: READER_ID_TYPE = @import("std").mem.zeroes(READER_ID_TYPE),
    value: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
};
pub const READER_IDA = struct__READER_IDA;
pub const LPREADER_IDA = [*c]struct__READER_IDA;
pub const READER_ID = READER_IDA;
pub const LPREADER_ID = LPREADER_IDA;
pub const struct__VERSIONW = extern struct {
    moduleName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    moduleVersion: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
};
pub const VERSIONW = struct__VERSIONW;
pub const LPVERSIONSW = [*c]struct__VERSIONW;
pub const struct__VERSIONA = extern struct {
    moduleName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    moduleVersion: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
};
pub const VERSIONA = struct__VERSIONA;
pub const LPVERSIONA = [*c]struct__VERSIONA;
pub const struct__READER_MODULE_VERSIONSW = extern struct {
    numVersions: UINT16 = @import("std").mem.zeroes(UINT16),
    pVersionList: [*c]VERSIONW = @import("std").mem.zeroes([*c]VERSIONW),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const READER_MODULE_VERSIONSW = struct__READER_MODULE_VERSIONSW;
pub const LPREADER_MODULE_VERSIONSW = [*c]struct__READER_MODULE_VERSIONSW;
pub const struct__READER_MODULE_VERSIONSA = extern struct {
    numVersions: UINT16 = @import("std").mem.zeroes(UINT16),
    pVersionList: [*c]VERSIONA = @import("std").mem.zeroes([*c]VERSIONA),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const READER_MODULE_VERSIONSA = struct__READER_MODULE_VERSIONSA;
pub const LPREADER_MODULE_VERSIONSA = [*c]struct__READER_MODULE_VERSIONSA;
pub const struct_READER_CAPSW = extern struct {
    structInfo: _STRUCT_INFO = @import("std").mem.zeroes(_STRUCT_INFO),
    readerID: READER_IDW = @import("std").mem.zeroes(READER_IDW),
    firmWareVersion: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    modelName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    numAntennas: UINT16 = @import("std").mem.zeroes(UINT16),
    numGPIs: UINT16 = @import("std").mem.zeroes(UINT16),
    numGPOs: UINT16 = @import("std").mem.zeroes(UINT16),
    utcClockSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    receiveSensitivtyTable: RECEIVE_SENSITIVITY_TABLE = @import("std").mem.zeroes(RECEIVE_SENSITIVITY_TABLE),
    perAntennaReceiveSensitivtyRange: PER_ANTENNA_RECEIVE_SENSITIVITY_RANGE = @import("std").mem.zeroes(PER_ANTENNA_RECEIVE_SENSITIVITY_RANGE),
    blockEraseSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    blockWriteSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    stateAwareSingulationSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    recommissionSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    blockPermalockSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    writeUMISupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    radioPowerControlSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    radioTransmitDelaySupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    maxNumOperationsInAccessSequence: UINT16 = @import("std").mem.zeroes(UINT16),
    maxNumPreFilters: UINT16 = @import("std").mem.zeroes(UINT16),
    rfModes: RF_MODES = @import("std").mem.zeroes(RF_MODES),
    countryCode: UINT16 = @import("std").mem.zeroes(UINT16),
    communicationStandard: COMMUNICATION_STANDARD = @import("std").mem.zeroes(COMMUNICATION_STANDARD),
    transmitPowerLevelTable: TRANSMIT_POWER_LEVEL_TABLE = @import("std").mem.zeroes(TRANSMIT_POWER_LEVEL_TABLE),
    hoppingEnabled: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    freqHopInfo: FREQ_HOP_INFO = @import("std").mem.zeroes(FREQ_HOP_INFO),
    fixedFreqInfo: FIXED_FREQ_INFO = @import("std").mem.zeroes(FIXED_FREQ_INFO),
    tagEventReportingSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    rssiFilterSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    NXPCommandsSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    tagLocationingSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpDutyCycleTable: LPDUTY_CYCLE_TABLE = @import("std").mem.zeroes(LPDUTY_CYCLE_TABLE),
    FujitsuCommandsSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    ImpinjCommandSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    SledBatteryStatusSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    TagListFilterSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpVersions: LPREADER_MODULE_VERSIONSW = @import("std").mem.zeroes(LPREADER_MODULE_VERSIONSW),
    PeriodicTagReportsSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    TagPhaseReportingSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    ZoneSuppported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    AntennaRFConfigSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    TagMovingStationarySupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    ZebraTriggerSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    G2V2CommandSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    GPSReportingSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    reserved: BYTE = @import("std").mem.zeroes(BYTE),
    reserved32: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [24]LPVOID = @import("std").mem.zeroes([24]LPVOID),
};
pub const READER_CAPSW = struct_READER_CAPSW;
pub const LPREADER_CAPSW = [*c]struct_READER_CAPSW;
pub const struct_READER_CAPSA = extern struct {
    structInfo: _STRUCT_INFO = @import("std").mem.zeroes(_STRUCT_INFO),
    readerID: READER_IDA = @import("std").mem.zeroes(READER_IDA),
    firmWareVersion: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    modelName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    numAntennas: UINT16 = @import("std").mem.zeroes(UINT16),
    numGPIs: UINT16 = @import("std").mem.zeroes(UINT16),
    numGPOs: UINT16 = @import("std").mem.zeroes(UINT16),
    utcClockSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    receiveSensitivtyTable: RECEIVE_SENSITIVITY_TABLE = @import("std").mem.zeroes(RECEIVE_SENSITIVITY_TABLE),
    perAntennaReceiveSensitivtyRange: PER_ANTENNA_RECEIVE_SENSITIVITY_RANGE = @import("std").mem.zeroes(PER_ANTENNA_RECEIVE_SENSITIVITY_RANGE),
    blockEraseSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    blockWriteSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    stateAwareSingulationSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    recommissionSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    blockPermalockSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    writeUMISupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    radioPowerControlSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    radioTransmitDelaySupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    maxNumOperationsInAccessSequence: UINT16 = @import("std").mem.zeroes(UINT16),
    maxNumPreFilters: UINT16 = @import("std").mem.zeroes(UINT16),
    rfModes: RF_MODES = @import("std").mem.zeroes(RF_MODES),
    countryCode: UINT16 = @import("std").mem.zeroes(UINT16),
    communicationStandard: COMMUNICATION_STANDARD = @import("std").mem.zeroes(COMMUNICATION_STANDARD),
    transmitPowerLevelTable: TRANSMIT_POWER_LEVEL_TABLE = @import("std").mem.zeroes(TRANSMIT_POWER_LEVEL_TABLE),
    hoppingEnabled: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    freqHopInfo: FREQ_HOP_INFO = @import("std").mem.zeroes(FREQ_HOP_INFO),
    fixedFreqInfo: FIXED_FREQ_INFO = @import("std").mem.zeroes(FIXED_FREQ_INFO),
    tagEventReportingSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    rssiFilterSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    NXPCommandsSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    tagLocationingSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpDutyCycleTable: LPDUTY_CYCLE_TABLE = @import("std").mem.zeroes(LPDUTY_CYCLE_TABLE),
    FujitsuCommandsSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    ImpinjCommandSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpVersions: LPREADER_MODULE_VERSIONSA = @import("std").mem.zeroes(LPREADER_MODULE_VERSIONSA),
    SledBatteryStatusSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    tagListFilterSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    PeriodicTagReportsSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    TagPhaseReportingSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    ZoneSuppported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    AntennaRFConfigSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    tagMovingStationarySupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    ZebraTriggerSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    G2V2CommandSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    GPSReportingSupported: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    reserved: BYTE = @import("std").mem.zeroes(BYTE),
    reserved32: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [24]LPVOID = @import("std").mem.zeroes([24]LPVOID),
};
pub const READER_CAPSA = struct_READER_CAPSA;
pub const LPREADER_CAPSA = [*c]struct_READER_CAPSA;
pub const READER_CAPS = READER_CAPSA;
pub const LPREADER_CAPS = LPREADER_CAPSA;
pub const struct__GPI_TRIGGER = extern struct {
    portNumber: UINT16 = @import("std").mem.zeroes(UINT16),
    gpiEvent: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    timeoutMilliseconds: UINT32 = @import("std").mem.zeroes(UINT32),
};
pub const GPI_TRIGGER = struct__GPI_TRIGGER;
pub const LPGPI_TRIGGER = [*c]struct__GPI_TRIGGER;
pub const struct__HANDHELD_TRIGGER = extern struct {
    handheldEvent: HANDHELD_TRIGGER_EVENT_TYPE = @import("std").mem.zeroes(HANDHELD_TRIGGER_EVENT_TYPE),
    timeoutMilliseconds: UINT32 = @import("std").mem.zeroes(UINT32),
};
pub const HANDHELD_TRIGGER = struct__HANDHELD_TRIGGER;
pub const LPHANDHELD_TRIGGER = [*c]struct__HANDHELD_TRIGGER;
pub const struct__TIMEOFDAY = extern struct {
    wHour: WORD = @import("std").mem.zeroes(WORD),
    wMinute: WORD = @import("std").mem.zeroes(WORD),
    wSecond: WORD = @import("std").mem.zeroes(WORD),
};
pub const TIMEOFDAY = struct__TIMEOFDAY;
pub const PTIMEOFDAY = [*c]struct__TIMEOFDAY;
pub const LPTIMEOFDAY = [*c]struct__TIMEOFDAY;
pub const struct__TIMELAPSE_START_TRIGGER = extern struct {
    startTime: [*c]TIMEOFDAY = @import("std").mem.zeroes([*c]TIMEOFDAY),
    period: UINT32 = @import("std").mem.zeroes(UINT32),
};
pub const TIMELAPSE_START_TRIGGER = struct__TIMELAPSE_START_TRIGGER;
pub const LPTIMELAPSE_START_TRIGGER = [*c]struct__TIMELAPSE_START_TRIGGER;
pub const struct__DISTANCE_TRIGGER = extern struct {
    value: UINT32 = @import("std").mem.zeroes(UINT32),
};
pub const DISTANCE_TRIGGER = struct__DISTANCE_TRIGGER;
pub const LPDISTANCE_TRIGGER = [*c]struct__DISTANCE_TRIGGER;
pub const struct__TIMELAPSE_STOP_TRIGGER = extern struct {
    totalDuration: UINT32 = @import("std").mem.zeroes(UINT32),
    periodicDuration: UINT32 = @import("std").mem.zeroes(UINT32),
};
pub const TIMELAPSE_STOP_TRIGGER = struct__TIMELAPSE_STOP_TRIGGER;
pub const LPTIMELAPSE_STOP_TRIGGER = [*c]struct__TIMELAPSE_STOP_TRIGGER;
pub const struct__TRIGGER_WITH_TIMEOUT = extern struct {
    n: UINT16 = @import("std").mem.zeroes(UINT16),
    timeoutMilliseconds: UINT32 = @import("std").mem.zeroes(UINT32),
};
pub const TRIGGER_WITH_TIMEOUT = struct__TRIGGER_WITH_TIMEOUT;
pub const LPTRIGGER_WITH_TIMEOUT = [*c]struct__TRIGGER_WITH_TIMEOUT;
pub const struct__PERIODIC_TRIGGER = extern struct {
    periodMilliseconds: UINT32 = @import("std").mem.zeroes(UINT32),
    startTime: [*c]SYSTEMTIME = @import("std").mem.zeroes([*c]SYSTEMTIME),
};
pub const PERIODIC_TRIGGER = struct__PERIODIC_TRIGGER;
pub const LPPERIODIC_TRIGGER = [*c]struct__PERIODIC_TRIGGER;
const union_unnamed_11 = extern union {
    gpi: GPI_TRIGGER,
    periodic: PERIODIC_TRIGGER,
    handheld: HANDHELD_TRIGGER,
    timelapse: TIMELAPSE_START_TRIGGER,
    distance: DISTANCE_TRIGGER,
};
pub const struct__START_TRIGGER = extern struct {
    type: START_TRIGGER_TYPE = @import("std").mem.zeroes(START_TRIGGER_TYPE),
    value: union_unnamed_11 = @import("std").mem.zeroes(union_unnamed_11),
};
pub const START_TRIGGER = struct__START_TRIGGER;
pub const LPSTART_TRIGGER = [*c]struct__START_TRIGGER;
const union_unnamed_12 = extern union {
    duration: UINT32,
    tagObservation: TRIGGER_WITH_TIMEOUT,
    numAttempts: TRIGGER_WITH_TIMEOUT,
    gpi: GPI_TRIGGER,
    handheld: HANDHELD_TRIGGER,
    timelapse: TIMELAPSE_STOP_TRIGGER,
};
pub const struct__STOP_TRIGGER = extern struct {
    type: STOP_TRIGGER_TYPE = @import("std").mem.zeroes(STOP_TRIGGER_TYPE),
    value: union_unnamed_12 = @import("std").mem.zeroes(union_unnamed_12),
};
pub const STOP_TRIGGER = struct__STOP_TRIGGER;
pub const LPSTOP_TRIGGER = [*c]struct__STOP_TRIGGER;
pub const struct__EXTRA_TRIGGER_INFO = extern struct {
    startTrigger: [7]START_TRIGGER = @import("std").mem.zeroes([7]START_TRIGGER),
    stopTrigger: [7]STOP_TRIGGER = @import("std").mem.zeroes([7]STOP_TRIGGER),
};
pub const EXTRA_TRIGGER_INFO = struct__EXTRA_TRIGGER_INFO;
pub const LPEXTRA_TRIGGER_INFO = [*c]struct__EXTRA_TRIGGER_INFO;
const union_unnamed_13 = extern union {
    duration: UINT32,
    numAttempts: UINT32,
};
pub const struct__STOP_TRIGGER_RFSURVEY = extern struct {
    type: STOP_TRIGGER_TYPE = @import("std").mem.zeroes(STOP_TRIGGER_TYPE),
    value: union_unnamed_13 = @import("std").mem.zeroes(union_unnamed_13),
};
pub const RFSURVEY_STOP_TRIGGER = struct__STOP_TRIGGER_RFSURVEY;
pub const LPRFSURVEY_STOP_TRIGGER = [*c]struct__STOP_TRIGGER_RFSURVEY;
pub const struct__TAG_EVENT_REPORT_INFO = extern struct {
    reportNewTagEvent: TAG_EVENT_REPORT_TRIGGER = @import("std").mem.zeroes(TAG_EVENT_REPORT_TRIGGER),
    newTagEventModeratedTimeoutMilliseconds: UINT16 = @import("std").mem.zeroes(UINT16),
    reportTagInvisibleEvent: TAG_EVENT_REPORT_TRIGGER = @import("std").mem.zeroes(TAG_EVENT_REPORT_TRIGGER),
    tagInvisibleEventModeratedTimeoutMilliseconds: UINT16 = @import("std").mem.zeroes(UINT16),
    reportTagBackToVisibilityEvent: TAG_EVENT_REPORT_TRIGGER = @import("std").mem.zeroes(TAG_EVENT_REPORT_TRIGGER),
    tagBackToVisibilityModeratedTimeoutMilliseconds: UINT16 = @import("std").mem.zeroes(UINT16),
    reportTagMovingEvent: TAG_MOVING_EVENT_REPORT = @import("std").mem.zeroes(TAG_MOVING_EVENT_REPORT),
    tagStationaryModeratedTimeoutMilliseconds: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const TAG_EVENT_REPORT_INFO = struct__TAG_EVENT_REPORT_INFO;
pub const LPTAG_EVENT_REPORT_INFO = [*c]struct__TAG_EVENT_REPORT_INFO;
pub const struct__REPORT_TRIGGERS = extern struct {
    periodicReportDuration: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const REPORT_TRIGGERS = struct__REPORT_TRIGGERS;
pub const LPREPORT_TRIGGERS = [*c]struct__REPORT_TRIGGERS;
pub const struct__TRIGGER_INFO = extern struct {
    startTrigger: START_TRIGGER = @import("std").mem.zeroes(START_TRIGGER),
    stopTrigger: STOP_TRIGGER = @import("std").mem.zeroes(STOP_TRIGGER),
    tagReportTrigger: UINT32 = @import("std").mem.zeroes(UINT32),
    lpTagEventReportInfo: LPTAG_EVENT_REPORT_INFO = @import("std").mem.zeroes(LPTAG_EVENT_REPORT_INFO),
    lpReportTriggers: LPREPORT_TRIGGERS = @import("std").mem.zeroes(LPREPORT_TRIGGERS),
    lpExtraTriggerInfo: LPEXTRA_TRIGGER_INFO = @import("std").mem.zeroes(LPEXTRA_TRIGGER_INFO),
    lpReserved: [1]LPVOID = @import("std").mem.zeroes([1]LPVOID),
};
pub const TRIGGER_INFO = struct__TRIGGER_INFO;
pub const LPTRIGGER_INFO = [*c]struct__TRIGGER_INFO;
pub const struct__TAG_ZONE_INFOW = extern struct {
    zoneID: UINT16 = @import("std").mem.zeroes(UINT16),
    zoneName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const TAG_ZONE_INFOW = struct__TAG_ZONE_INFOW;
pub const LPTAG_ZONE_INFOW = [*c]struct__TAG_ZONE_INFOW;
pub const struct__TAG_ZONE_INFOA = extern struct {
    zoneID: UINT16 = @import("std").mem.zeroes(UINT16),
    zoneName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const TAG_ZONE_INFOA = struct__TAG_ZONE_INFOA;
pub const LPTAG_ZONE_INFOA = [*c]struct__TAG_ZONE_INFOA;
pub const TAG_ZONE_INFO = TAG_ZONE_INFOA;
pub const LPTAG_ZONE_INFO = LPTAG_ZONE_INFOA;
pub const struct__UP_TIME_15 = extern struct {
    firstSeenTimeStamp: UINT64 = @import("std").mem.zeroes(UINT64),
    lastSeenTimeStamp: UINT64 = @import("std").mem.zeroes(UINT64),
};
pub const struct__UTC_TIME_16 = extern struct {
    firstSeenTimeStamp: SYSTEMTIME = @import("std").mem.zeroes(SYSTEMTIME),
    lastSeenTimeStamp: SYSTEMTIME = @import("std").mem.zeroes(SYSTEMTIME),
};
const union_unnamed_14 = extern union {
    upTime: struct__UP_TIME_15,
    utcTime: struct__UTC_TIME_16,
};
pub const struct__TAG_DATA = extern struct {
    structInfo: _STRUCT_INFO = @import("std").mem.zeroes(_STRUCT_INFO),
    pTagID: [*c]UINT8 = @import("std").mem.zeroes([*c]UINT8),
    tagIDLength: UINT32 = @import("std").mem.zeroes(UINT32),
    tagIDAllocated: UINT32 = @import("std").mem.zeroes(UINT32),
    PC: UINT16 = @import("std").mem.zeroes(UINT16),
    XPC: UINT32 = @import("std").mem.zeroes(UINT32),
    CRC: UINT16 = @import("std").mem.zeroes(UINT16),
    antennaID: UINT16 = @import("std").mem.zeroes(UINT16),
    seenTime: union_unnamed_14 = @import("std").mem.zeroes(union_unnamed_14),
    peakRSSI: INT8 = @import("std").mem.zeroes(INT8),
    channelIndex: UINT16 = @import("std").mem.zeroes(UINT16),
    tagSeenCount: UINT16 = @import("std").mem.zeroes(UINT16),
    opCode: ACCESS_OPERATION_CODE = @import("std").mem.zeroes(ACCESS_OPERATION_CODE),
    opStatus: ACCESS_OPERATION_STATUS = @import("std").mem.zeroes(ACCESS_OPERATION_STATUS),
    memoryBank: MEMORY_BANK = @import("std").mem.zeroes(MEMORY_BANK),
    pMemoryBankData: [*c]UINT8 = @import("std").mem.zeroes([*c]UINT8),
    memoryBankDataByteOffset: UINT32 = @import("std").mem.zeroes(UINT32),
    memoryBankDataLength: UINT32 = @import("std").mem.zeroes(UINT32),
    memoryBankDataAllocated: UINT32 = @import("std").mem.zeroes(UINT32),
    tagEvent: TAG_EVENT = @import("std").mem.zeroes(TAG_EVENT),
    tagEventTimeStamp: SYSTEMTIME = @import("std").mem.zeroes(SYSTEMTIME),
    lpLocation: LPLOCATION_INFO = @import("std").mem.zeroes(LPLOCATION_INFO),
    lpAccessOperationResult: LPACCESS_OPERATION_RESULT = @import("std").mem.zeroes(LPACCESS_OPERATION_RESULT),
    transmitPort: UINT16 = @import("std").mem.zeroes(UINT16),
    receivePort: UINT16 = @import("std").mem.zeroes(UINT16),
    lpZoneInfo: LPTAG_ZONE_INFO = @import("std").mem.zeroes(LPTAG_ZONE_INFO),
    phaseInfo: INT16 = @import("std").mem.zeroes(INT16),
    brandValid: UINT8 = @import("std").mem.zeroes(UINT8),
    reserved: UINT8 = @import("std").mem.zeroes(UINT8),
    lpMLTAlogrithmReport: LPMLT_ALGORITHM_REPORT = @import("std").mem.zeroes(LPMLT_ALGORITHM_REPORT),
    lpGPSLocation: LPGPS_LOCATION = @import("std").mem.zeroes(LPGPS_LOCATION),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const TAG_DATA = struct__TAG_DATA;
pub const LPTAG_DATA = [*c]struct__TAG_DATA;
pub const struct__UP_TIME_RFSURVEY_18 = extern struct {
    firstSeenTimeStamp: UINT64 = @import("std").mem.zeroes(UINT64),
};
pub const struct__UTC_TIME_RFSURVEY_19 = extern struct {
    firstSeenTimeStamp: SYSTEMTIME = @import("std").mem.zeroes(SYSTEMTIME),
};
const union_unnamed_17 = extern union {
    upTime: struct__UP_TIME_RFSURVEY_18,
    utcTime: struct__UTC_TIME_RFSURVEY_19,
};
pub const struct__RF_SURVEY_DATA = extern struct {
    structInfo: _STRUCT_INFO = @import("std").mem.zeroes(_STRUCT_INFO),
    seenTime: union_unnamed_17 = @import("std").mem.zeroes(union_unnamed_17),
    frequency: UINT32 = @import("std").mem.zeroes(UINT32),
    bandWidth: UINT32 = @import("std").mem.zeroes(UINT32),
    averagePeakRSSI: INT8 = @import("std").mem.zeroes(INT8),
    peakRSSI: INT8 = @import("std").mem.zeroes(INT8),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const RF_SURVEY_DATA = struct__RF_SURVEY_DATA;
pub const LPRFSURVEY_DATA = [*c]struct__RF_SURVEY_DATA;
pub const struct__TAG_STORAGE_SETTINGS = extern struct {
    maxTagCount: UINT32 = @import("std").mem.zeroes(UINT32),
    maxMemoryBankByteCount: UINT32 = @import("std").mem.zeroes(UINT32),
    maxTagIDByteCount: UINT32 = @import("std").mem.zeroes(UINT32),
    tagFields: UINT16 = @import("std").mem.zeroes(UINT16),
    enableAccessReports: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    discardTagsOnInventoryStop: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    enablePreFilters: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    reserved: [3]BYTE = @import("std").mem.zeroes([3]BYTE),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const TAG_STORAGE_SETTINGS = struct__TAG_STORAGE_SETTINGS;
pub const LPTAG_STORAGE_SETTINGS = [*c]struct__TAG_STORAGE_SETTINGS;
pub const struct__RFSURVEY_STORAGE_SETTINGS = extern struct {
    maxRFSurveyCount: UINT32 = @import("std").mem.zeroes(UINT32),
    maxMemoryBankByteCount: UINT32 = @import("std").mem.zeroes(UINT32),
    maxRFSurveyIDByteCount: UINT32 = @import("std").mem.zeroes(UINT32),
    rfsurveyFields: UINT16 = @import("std").mem.zeroes(UINT16),
    enableAccessReports: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    reserved32: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const RFSURVEY_STORAGE_SETTINGS = struct__RFSURVEY_STORAGE_SETTINGS;
pub const LPRFSURVEY_STORAGE_SETTINGS = [*c]struct__RFSURVEY_STORAGE_SETTINGS;
pub const struct__DISCONNECTION_EVENT_DATA = extern struct {
    eventInfo: DISCONNECTION_EVENT_TYPE = @import("std").mem.zeroes(DISCONNECTION_EVENT_TYPE),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const DISCONNECTION_EVENT_DATA = struct__DISCONNECTION_EVENT_DATA;
pub const LPDISCONNECTION_EVENT_DATA = [*c]struct__DISCONNECTION_EVENT_DATA;
pub const struct__READER_EXCEPTION_EVENT_DATAW = extern struct {
    exceptionType: READER_EXCEPTION_EVENT_TYPE = @import("std").mem.zeroes(READER_EXCEPTION_EVENT_TYPE),
    exceptionInfo: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const READER_EXCEPTION_EVENT_DATAW = struct__READER_EXCEPTION_EVENT_DATAW;
pub const LPREADER_EXCEPTION_EVENT_DATAW = [*c]struct__READER_EXCEPTION_EVENT_DATAW;
pub const struct__READER_EXCEPTION_EVENT_DATAA = extern struct {
    exceptionType: READER_EXCEPTION_EVENT_TYPE = @import("std").mem.zeroes(READER_EXCEPTION_EVENT_TYPE),
    exceptionInfo: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const READER_EXCEPTION_EVENT_DATAA = struct__READER_EXCEPTION_EVENT_DATAA;
pub const LPREADER_EXCEPTION_EVENT_DATAA = [*c]struct__READER_EXCEPTION_EVENT_DATAA;
pub const READER_EXCEPTION_EVENT_DATA = READER_EXCEPTION_EVENT_DATAA;
pub const LPREADER_EXCEPTION_EVENT_DATA = LPREADER_EXCEPTION_EVENT_DATAA;
pub const struct__ANTENNA_EVENT_DATA = extern struct {
    id: UINT16 = @import("std").mem.zeroes(UINT16),
    eventInfo: ANTENNA_EVENT_TYPE = @import("std").mem.zeroes(ANTENNA_EVENT_TYPE),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const ANTENNA_EVENT_DATA = struct__ANTENNA_EVENT_DATA;
pub const LPANTENNA_EVENT_DATA = [*c]struct__ANTENNA_EVENT_DATA;
pub const struct__GPI_EVENT_DATA = extern struct {
    port: UINT16 = @import("std").mem.zeroes(UINT16),
    eventInfo: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const GPI_EVENT_DATA = struct__GPI_EVENT_DATA;
pub const LPGPI_EVENT_DATA = [*c]struct__GPI_EVENT_DATA;
pub const struct__HANDHELD_EVENT_DATA = extern struct {
    eventInfo: HANDHELD_TRIGGER_EVENT_TYPE = @import("std").mem.zeroes(HANDHELD_TRIGGER_EVENT_TYPE),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const HANDHELD_TRIGGER_EVENT_DATA = struct__HANDHELD_EVENT_DATA;
pub const LPHANDHELD_EVENT_DATA = [*c]struct__HANDHELD_EVENT_DATA;
pub const struct__NXP_EAS_ALARM_DATA = extern struct {
    alarmCode: UINT64 = @import("std").mem.zeroes(UINT64),
    antennaID: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const NXP_EAS_ALARM_DATA = struct__NXP_EAS_ALARM_DATA;
pub const LPNXP_EAS_ALARM_DATA = [*c]struct__NXP_EAS_ALARM_DATA;
pub const struct__DEBUG_INFO_DATAW = extern struct {
    szDebugInfo: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const DEBUG_INFO_DATAW = struct__DEBUG_INFO_DATAW;
pub const LPDEBUG_INFO_DATAW = [*c]struct__DEBUG_INFO_DATAW;
pub const struct__DEBUG_INFO_DATAA = extern struct {
    szDebugInfo: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const DEBUG_INFO_DATAA = struct__DEBUG_INFO_DATAA;
pub const LPDEBUG_INFO_DATAA = [*c]struct__DEBUG_INFO_DATAA;
pub const DEBUG_INFO_DATA = DEBUG_INFO_DATAA;
pub const LPDEBUG_INFO_DATA = LPDEBUG_INFO_DATAA;
pub const struct__TEMPERATURE_ALARM_DATA = extern struct {
    sourceName: TEMPERATURE_SOURCE = @import("std").mem.zeroes(TEMPERATURE_SOURCE),
    currentTemperature: UINT16 = @import("std").mem.zeroes(UINT16),
    alarmLevel: ALARM_LEVEL = @import("std").mem.zeroes(ALARM_LEVEL),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const TEMPERATURE_ALARM_DATA = struct__TEMPERATURE_ALARM_DATA;
pub const LPTEMPERATURE_ALARM_DATA = [*c]struct__TEMPERATURE_ALARM_DATA;
pub const struct__STATE_AWARE_ACTION_PARAMS = extern struct {
    target: TARGET = @import("std").mem.zeroes(TARGET),
    stateAwareAction: STATE_AWARE_ACTION = @import("std").mem.zeroes(STATE_AWARE_ACTION),
};
pub const STATE_AWARE_ACTION_PARAMS = struct__STATE_AWARE_ACTION_PARAMS;
pub const LPSTATE_AWARE_ACTION_PARAMS = [*c]struct__STATE_AWARE_ACTION_PARAMS;
const union_unnamed_20 = extern union {
    stateAwareParams: STATE_AWARE_ACTION_PARAMS,
    stateUnawareAction: STATE_UNAWARE_ACTION,
};
pub const struct__PRE_FILTER = extern struct {
    memoryBank: MEMORY_BANK = @import("std").mem.zeroes(MEMORY_BANK),
    pTagPattern: [*c]UINT8 = @import("std").mem.zeroes([*c]UINT8),
    tagPatternBitCount: UINT16 = @import("std").mem.zeroes(UINT16),
    bitOffset: UINT16 = @import("std").mem.zeroes(UINT16),
    filterAction: FILTER_ACTION = @import("std").mem.zeroes(FILTER_ACTION),
    filterActionParams: union_unnamed_20 = @import("std").mem.zeroes(union_unnamed_20),
    truncateAction: TRUNCATE_ACTION = @import("std").mem.zeroes(TRUNCATE_ACTION),
    lpReserved: [3]LPVOID = @import("std").mem.zeroes([3]LPVOID),
};
pub const PRE_FILTER = struct__PRE_FILTER;
pub const LPPRE_FILTER = [*c]struct__PRE_FILTER;
pub const struct__PRE_FILTER_LIST = extern struct {
    preFilterCount: UINT32 = @import("std").mem.zeroes(UINT32),
    lpPreFilters: [*c]PRE_FILTER = @import("std").mem.zeroes([*c]PRE_FILTER),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const PRE_FILTER_LIST = struct__PRE_FILTER_LIST;
pub const LPPRE_FILTER_LIST = [*c]struct__PRE_FILTER_LIST;
pub const struct__ANTENNA_STOP_TRIGGER = extern struct {
    stopTriggerType: ANTENNA_STOP_TRIGGER_TYPE = @import("std").mem.zeroes(ANTENNA_STOP_TRIGGER_TYPE),
    stopTriggerValue: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const ANTENNA_STOP_TRIGGER = struct__ANTENNA_STOP_TRIGGER;
pub const LPANTENNA_STOP_TRIGGER = [*c]struct__ANTENNA_STOP_TRIGGER;
pub const struct__ANTENNA_RF_CONFIG = extern struct {
    transmitPowerIndex: UINT16 = @import("std").mem.zeroes(UINT16),
    receiveSensitivityIndex: UINT16 = @import("std").mem.zeroes(UINT16),
    transmitFrequencyIndex: UINT16 = @import("std").mem.zeroes(UINT16),
    rfModeTableIndex: UINT32 = @import("std").mem.zeroes(UINT32),
    tari: UINT32 = @import("std").mem.zeroes(UINT32),
    transmitPort: UINT16 = @import("std").mem.zeroes(UINT16),
    receivePort: UINT16 = @import("std").mem.zeroes(UINT16),
    antennaStopTrigger: ANTENNA_STOP_TRIGGER = @import("std").mem.zeroes(ANTENNA_STOP_TRIGGER),
    extendedOnTimeMicroseconds: UINT16 = @import("std").mem.zeroes(UINT16),
    reserved: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [31]LPVOID = @import("std").mem.zeroes([31]LPVOID),
};
pub const ANTENNA_RF_CONFIG = struct__ANTENNA_RF_CONFIG;
pub const LPANTENNA_RF_CONFIG = [*c]struct__ANTENNA_RF_CONFIG;
pub const struct__ANTENNA_CONFIG = extern struct {
    antennaID: UINT16 = @import("std").mem.zeroes(UINT16),
    lpAntennaRfConfig: LPANTENNA_RF_CONFIG = @import("std").mem.zeroes(LPANTENNA_RF_CONFIG),
    lpPreFilterList: LPPRE_FILTER_LIST = @import("std").mem.zeroes(LPPRE_FILTER_LIST),
    lpSingulationControl: LPSINGULATION_CONTROL = @import("std").mem.zeroes(LPSINGULATION_CONTROL),
    lpReserved: [32]LPVOID = @import("std").mem.zeroes([32]LPVOID),
};
pub const ANTENNA_CONFIG = struct__ANTENNA_CONFIG;
pub const LPANTENNA_CONFIG = [*c]struct__ANTENNA_CONFIG;
pub const struct__ZONE_CONFIGW = extern struct {
    ZoneName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    antennaCount: UINT32 = @import("std").mem.zeroes(UINT32),
    lpAntennaConfigurations: [*c]ANTENNA_CONFIG = @import("std").mem.zeroes([*c]ANTENNA_CONFIG),
    lpZoneGlobalAntennaConfiguration: LPANTENNA_CONFIG = @import("std").mem.zeroes(LPANTENNA_CONFIG),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const ZONE_CONFIGW = struct__ZONE_CONFIGW;
pub const LPZONE_CONFIGW = [*c]struct__ZONE_CONFIGW;
pub const struct__ZONE_CONFIGA = extern struct {
    ZoneName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    antennaCount: UINT32 = @import("std").mem.zeroes(UINT32),
    lpAntennaConfigurations: [*c]ANTENNA_CONFIG = @import("std").mem.zeroes([*c]ANTENNA_CONFIG),
    lpZoneGlobalAntennaConfiguration: LPANTENNA_CONFIG = @import("std").mem.zeroes(LPANTENNA_CONFIG),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const ZONE_CONFIGA = struct__ZONE_CONFIGA;
pub const LPZONE_CONFIGA = [*c]struct__ZONE_CONFIGA;
pub const ZONE_CONFIG = ZONE_CONFIGA;
pub const LPZONE_CONFIG = LPZONE_CONFIGA;
pub const struct__ZONE_INFO = extern struct {
    zoneID: UINT32 = @import("std").mem.zeroes(UINT32),
    pAntennaList: [*c]UINT16 = @import("std").mem.zeroes([*c]UINT16),
    antennaListLength: UINT32 = @import("std").mem.zeroes(UINT32),
    zoneOperation: OPERATION_QUALIFIER = @import("std").mem.zeroes(OPERATION_QUALIFIER),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const ZONE_INFO = struct__ZONE_INFO;
pub const LPZONE_INFO = [*c]struct__ZONE_INFO;
pub const struct__DEBUG_INFO_PARAMS = extern struct {
    byteOffset: UINT16 = @import("std").mem.zeroes(UINT16),
    pDebugMask: [*c]UINT8 = @import("std").mem.zeroes([*c]UINT8),
    debugMaskByteCount: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const DEBUG_INFO_PARAMS = struct__DEBUG_INFO_PARAMS;
pub const LPDEBUG_INFO_PARAMS = [*c]struct__DEBUG_INFO_PARAMS;
pub const struct__ZONE_SEQUENCE = extern struct {
    zoneListCount: UINT32 = @import("std").mem.zeroes(UINT32),
    pZoneList: LPZONE_INFO = @import("std").mem.zeroes(LPZONE_INFO),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const ZONE_SEQUENCE = struct__ZONE_SEQUENCE;
pub const LPZONE_SEQUENCE = [*c]struct__ZONE_SEQUENCE;
pub const struct__TAG_PATTERN = extern struct {
    memoryBank: MEMORY_BANK = @import("std").mem.zeroes(MEMORY_BANK),
    bitOffset: UINT16 = @import("std").mem.zeroes(UINT16),
    pTagPattern: [*c]UINT8 = @import("std").mem.zeroes([*c]UINT8),
    tagPatternBitCount: UINT16 = @import("std").mem.zeroes(UINT16),
    pTagMask: [*c]UINT8 = @import("std").mem.zeroes([*c]UINT8),
    tagMaskBitCount: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const TAG_PATTERN = struct__TAG_PATTERN;
pub const LPTAG_PATTERN = [*c]struct__TAG_PATTERN;
pub const struct__RSSI_RANGE_FILTER = extern struct {
    peakRSSILowerLimit: INT8 = @import("std").mem.zeroes(INT8),
    peakRSSIUpperLimit: INT8 = @import("std").mem.zeroes(INT8),
    matchRange: MATCH_RANGE = @import("std").mem.zeroes(MATCH_RANGE),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const RSSI_RANGE_FILTER = struct__RSSI_RANGE_FILTER;
pub const LPRSSI_RANGE_FILTER = [*c]struct__RSSI_RANGE_FILTER;
pub const struct__TAG_LIST_FILTER = extern struct {
    matchTagList: MATCH_TAG_LIST = @import("std").mem.zeroes(MATCH_TAG_LIST),
    tagCount: UINT32 = @import("std").mem.zeroes(UINT32),
    tagList: [256]LPTAG_DATA = @import("std").mem.zeroes([256]LPTAG_DATA),
};
pub const TAG_LIST_FILTER = struct__TAG_LIST_FILTER;
pub const LPTAG_LIST_FILTER = [*c]struct__TAG_LIST_FILTER;
pub const struct__POST_FILTER = extern struct {
    structInfo: _STRUCT_INFO = @import("std").mem.zeroes(_STRUCT_INFO),
    lpTagPatternA: LPTAG_PATTERN = @import("std").mem.zeroes(LPTAG_PATTERN),
    lpTagPatternB: LPTAG_PATTERN = @import("std").mem.zeroes(LPTAG_PATTERN),
    matchPattern: MATCH_PATTERN = @import("std").mem.zeroes(MATCH_PATTERN),
    lpRSSIRangeFilter: LPRSSI_RANGE_FILTER = @import("std").mem.zeroes(LPRSSI_RANGE_FILTER),
    lpTagListFilter: LPTAG_LIST_FILTER = @import("std").mem.zeroes(LPTAG_LIST_FILTER),
    lpReserved: [14]LPVOID = @import("std").mem.zeroes([14]LPVOID),
};
pub const POST_FILTER = struct__POST_FILTER;
pub const LPPOST_FILTER = [*c]struct__POST_FILTER;
pub const struct__ACCESS_FILTER = extern struct {
    structInfo: _STRUCT_INFO = @import("std").mem.zeroes(_STRUCT_INFO),
    lpTagPatternA: LPTAG_PATTERN = @import("std").mem.zeroes(LPTAG_PATTERN),
    lpTagPatternB: LPTAG_PATTERN = @import("std").mem.zeroes(LPTAG_PATTERN),
    matchPattern: MATCH_PATTERN = @import("std").mem.zeroes(MATCH_PATTERN),
    lpRSSIRangeFilter: LPRSSI_RANGE_FILTER = @import("std").mem.zeroes(LPRSSI_RANGE_FILTER),
    lpReserved: [15]LPVOID = @import("std").mem.zeroes([15]LPVOID),
};
pub const ACCESS_FILTER = struct__ACCESS_FILTER;
pub const LPACCESS_FILTER = [*c]struct__ACCESS_FILTER;
pub const struct__READ_ACCESS_PARAMS = extern struct {
    memoryBank: MEMORY_BANK = @import("std").mem.zeroes(MEMORY_BANK),
    byteOffset: UINT16 = @import("std").mem.zeroes(UINT16),
    byteCount: UINT16 = @import("std").mem.zeroes(UINT16),
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const READ_ACCESS_PARAMS = struct__READ_ACCESS_PARAMS;
pub const LPREAD_ACCESS_PARAMS = [*c]struct__READ_ACCESS_PARAMS;
pub const struct__WRITE_ACCESS_PARAMS = extern struct {
    memoryBank: MEMORY_BANK = @import("std").mem.zeroes(MEMORY_BANK),
    byteOffset: UINT16 = @import("std").mem.zeroes(UINT16),
    pWriteData: [*c]UINT8 = @import("std").mem.zeroes([*c]UINT8),
    writeDataLength: UINT16 = @import("std").mem.zeroes(UINT16),
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const WRITE_ACCESS_PARAMS = struct__WRITE_ACCESS_PARAMS;
pub const LPWRITE_ACCESS_PARAMS = [*c]struct__WRITE_ACCESS_PARAMS;
pub const struct__WRITE_SPECIFIC_FIELD_ACCESS_PARAMS = extern struct {
    pWriteData: [*c]UINT8 = @import("std").mem.zeroes([*c]UINT8),
    writeDataLength: UINT16 = @import("std").mem.zeroes(UINT16),
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const WRITE_SPECIFIC_FIELD_ACCESS_PARAMS = struct__WRITE_SPECIFIC_FIELD_ACCESS_PARAMS;
pub const LPWRITE_SPECIFIC_FIELD_ACCESS_PARAMS = [*c]struct__WRITE_SPECIFIC_FIELD_ACCESS_PARAMS;
pub const struct__KILL_ACCESS_PARAMS = extern struct {
    killPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const KILL_ACCESS_PARAMS = struct__KILL_ACCESS_PARAMS;
pub const LPKILL_ACCESS_PARAMS = [*c]struct__KILL_ACCESS_PARAMS;
pub const struct__LOCK_ACCESS_PARAMS = extern struct {
    privilege: [5]LOCK_PRIVILEGE = @import("std").mem.zeroes([5]LOCK_PRIVILEGE),
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const LOCK_ACCESS_PARAMS = struct__LOCK_ACCESS_PARAMS;
pub const LPLOCK_ACCESS_PARAMS = [*c]struct__LOCK_ACCESS_PARAMS;
pub const struct__BLOCK_ERASE_ACCESS_PARAMS = extern struct {
    memoryBank: MEMORY_BANK = @import("std").mem.zeroes(MEMORY_BANK),
    byteOffset: UINT16 = @import("std").mem.zeroes(UINT16),
    byteCount: UINT16 = @import("std").mem.zeroes(UINT16),
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const BLOCK_ERASE_ACCESS_PARAMS = struct__BLOCK_ERASE_ACCESS_PARAMS;
pub const LPBLOCK_ERASE_ACCESS_PARAMS = [*c]struct__BLOCK_ERASE_ACCESS_PARAMS;
pub const struct__RECOMMISSION_ACCESS_PARAMS = extern struct {
    killPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    opCode: RECOMMISSION_OPERATION_CODE = @import("std").mem.zeroes(RECOMMISSION_OPERATION_CODE),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const RECOMMISSION_ACCESS_PARAMS = struct__RECOMMISSION_ACCESS_PARAMS;
pub const LPRECOMMISSION_ACCESS_PARAMS = [*c]struct__RECOMMISSION_ACCESS_PARAMS;
pub const struct__BLOCK_PERMALOCK_ACCESS_PARAMS = extern struct {
    memoryBank: MEMORY_BANK = @import("std").mem.zeroes(MEMORY_BANK),
    readLock: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    byteOffset: UINT16 = @import("std").mem.zeroes(UINT16),
    byteCount: UINT16 = @import("std").mem.zeroes(UINT16),
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    pMask: [*c]UINT8 = @import("std").mem.zeroes([*c]UINT8),
    maskLength: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const BLOCK_PERMALOCK_ACCESS_PARAMS = struct__BLOCK_PERMALOCK_ACCESS_PARAMS;
pub const LPBLOCK_PERMALOCK_ACCESS_PARAMS = [*c]struct__BLOCK_PERMALOCK_ACCESS_PARAMS;
pub const struct__AUTHENTICATE_ACCESS_PARAMS = extern struct {
    senResp: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    incRespLen: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    CSI: UINT8 = @import("std").mem.zeroes(UINT8),
    length: UINT16 = @import("std").mem.zeroes(UINT16),
    pMessage: [*c]UINT8 = @import("std").mem.zeroes([*c]UINT8),
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const AUTHENTICATE_ACCESS_PARAMS = struct__AUTHENTICATE_ACCESS_PARAMS;
pub const LPAUTHENTICATE_ACCESS_PARAMS = [*c]struct__AUTHENTICATE_ACCESS_PARAMS;
pub const struct__READBUFFER_ACCESS_PARAMS = extern struct {
    wordPtr: UINT16 = @import("std").mem.zeroes(UINT16),
    bitCount: UINT16 = @import("std").mem.zeroes(UINT16),
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const READBUFFER_ACCESS_PARAMS = struct__READBUFFER_ACCESS_PARAMS;
pub const LPREADBUFFER_ACCESS_PARAMS = [*c]struct__READBUFFER_ACCESS_PARAMS;
pub const struct__UNTRACEABLE_ACCESS_PARAMS = extern struct {
    assertU: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    hideEPC: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    EPCLength: UINT8 = @import("std").mem.zeroes(UINT8),
    hideTID: TID_HIDE_STATE = @import("std").mem.zeroes(TID_HIDE_STATE),
    hideUser: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    operatingRange: TAG_OPERATING_RANGE = @import("std").mem.zeroes(TAG_OPERATING_RANGE),
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const UNTRACEABLE_ACCESS_PARAMS = struct__UNTRACEABLE_ACCESS_PARAMS;
pub const LPUNTRACEABLE_ACCESS_PARAMS = [*c]struct__UNTRACEABLE_ACCESS_PARAMS;
pub const struct__CRYPTO_ACCESS_PARAMS = extern struct {
    keyID: UINT8 = @import("std").mem.zeroes(UINT8),
    IChallenge: [3]UINT32 = @import("std").mem.zeroes([3]UINT32),
    customData: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    profile: UINT8 = @import("std").mem.zeroes(UINT8),
    offset: UINT8 = @import("std").mem.zeroes(UINT8),
    blockCount: UINT8 = @import("std").mem.zeroes(UINT8),
    protMode: UINT8 = @import("std").mem.zeroes(UINT8),
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const CRYPTO_ACCESS_PARAMS = struct__CRYPTO_ACCESS_PARAMS;
pub const LPCRYPTO_ACCESS_PARAMS = [*c]struct__CRYPTO_ACCESS_PARAMS;
pub const struct__OP_CODE_PARAMS = extern struct {
    opCode: ACCESS_OPERATION_CODE = @import("std").mem.zeroes(ACCESS_OPERATION_CODE),
    opParams: STRUCT_HANDLE = @import("std").mem.zeroes(STRUCT_HANDLE),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const OP_CODE_PARAMS = struct__OP_CODE_PARAMS;
pub const LPOP_CODE_PARAMS = [*c]struct__OP_CODE_PARAMS;
pub const struct__READER_STATS = extern struct {
    identifiedSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    identifiedFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    readSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    readFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    writeSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    writeFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    killSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    killFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    lockSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    lockFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    blockWriteSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    blockWriteFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    blockEraseSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    blockEraseFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    blockPermalockSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    blockPermalockFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    nxpChangeEASSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    nxpChangeEASFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    nxpEASAlarmSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    nxpEASAlarmFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    nxpReadProtectSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    nxpReadProtectFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    nxpResetReadProtectSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    nxpResetReadProtectFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    nxpCalibrateSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    nxpCalibrateFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    nxpchangeConfigSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    nxpchangeConfigFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuChangeWordLockSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuChangeWordLockFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuChangeBlockLockSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuChangeBlockLockFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuReadBlockLockSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuReadBlockLockFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuChangeBlockOrAreaGroupPasswordSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuChangeBlockOrAreaGroupPasswordFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuBurstWriteSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuBurstWriteFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuBurstEraseSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuBurstEraseFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuAreaReadLockSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuAreaReadLockFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuAreaWriteLockSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuAreaWriteLockFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuAreaWriteLockWOPasswordSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    fujitsuAreaWriteLockWOPasswordFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    impinjQTOperationSuccessCount: UINT32 = @import("std").mem.zeroes(UINT32),
    impinjQTOperationFailureCount: UINT32 = @import("std").mem.zeroes(UINT32),
    ambientTemperatureHighAlarmCount: UINT32 = @import("std").mem.zeroes(UINT32),
    ambientTemperatureCriticalAlarmCount: UINT32 = @import("std").mem.zeroes(UINT32),
    paTemperatureHighAlarmCount: UINT32 = @import("std").mem.zeroes(UINT32),
    paTemperatureCriticalAlarmCount: UINT32 = @import("std").mem.zeroes(UINT32),
    forwardPowerHighAlarmCount: UINT32 = @import("std").mem.zeroes(UINT32),
    forwardPowerLowAlarmCount: UINT32 = @import("std").mem.zeroes(UINT32),
    reversePowerHighAlarmCount: UINT32 = @import("std").mem.zeroes(UINT32),
    echoThresholdAlarmCount: UINT32 = @import("std").mem.zeroes(UINT32),
    databaseWarningCount: UINT32 = @import("std").mem.zeroes(UINT32),
    databaseErrorCount: UINT32 = @import("std").mem.zeroes(UINT32),
    gpioInformationCount: UINT32 = @import("std").mem.zeroes(UINT32),
    reserved32: [37]UINT32 = @import("std").mem.zeroes([37]UINT32),
    lpReserved: [16]LPVOID = @import("std").mem.zeroes([16]LPVOID),
};
pub const READER_STATS = struct__READER_STATS;
pub const LPREADER_STATS = [*c]struct__READER_STATS;
pub const struct__VERSION_INFOW = extern struct {
    dllVersion: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
};
pub const VERSION_INFOW = struct__VERSION_INFOW;
pub const LPVERSION_INFOW = [*c]struct__VERSION_INFOW;
pub const struct__VERSION_INFOA = extern struct {
    dllVersion: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
};
pub const VERSION_INFOA = struct__VERSION_INFOA;
pub const LPVERSION_INFOA = [*c]struct__VERSION_INFOA;
pub const VERSION_INFO = VERSION_INFOA;
pub const LPVERSION_INFO = LPVERSION_INFOA;
pub const struct__LOGIN_INFOW = extern struct {
    hostName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    userName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    password: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    version: RFID_VERSION = @import("std").mem.zeroes(RFID_VERSION),
    forceLogin: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    reserved1: [3]BYTE = @import("std").mem.zeroes([3]BYTE),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const LOGIN_INFOW = struct__LOGIN_INFOW;
pub const LPLOGIN_INFOW = [*c]struct__LOGIN_INFOW;
pub const struct__FTPSERVER_INFOW = extern struct {
    hostName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    userName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    password: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const FTPSERVER_INFOW = struct__FTPSERVER_INFOW;
pub const LPFTPSERVER_INFOW = [*c]struct__FTPSERVER_INFOW;
pub const struct__LOGIN_INFOA = extern struct {
    hostName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    userName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    password: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    version: RFID_VERSION = @import("std").mem.zeroes(RFID_VERSION),
    forceLogin: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    reserved1: [3]BYTE = @import("std").mem.zeroes([3]BYTE),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const LOGIN_INFOA = struct__LOGIN_INFOA;
pub const LPLOGIN_INFOA = [*c]struct__LOGIN_INFOA;
pub const struct__FTPSERVER_INFOA = extern struct {
    hostName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    userName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    password: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const FTPSERVER_INFOA = struct__FTPSERVER_INFOA;
pub const LPFTPSERVER_INFOA = [*c]struct__FTPSERVER_INFOA;
pub const LOGIN_INFO = LOGIN_INFOA;
pub const LPLOGIN_INFO = LPLOGIN_INFOA;
pub const LPFTPSERVER_INFO = LPFTPSERVER_INFOA;
pub const FTPSERVER_INFO = FTPSERVER_INFOA;
pub const struct__UPDATE_STATUSW = extern struct {
    percentage: UINT32 = @import("std").mem.zeroes(UINT32),
    updateInfo: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const UPDATE_STATUSW = struct__UPDATE_STATUSW;
pub const LPUPDATE_STATUSW = [*c]struct__UPDATE_STATUSW;
pub const struct__UPDATE_STATUSA = extern struct {
    percentage: UINT32 = @import("std").mem.zeroes(UINT32),
    updateInfo: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const UPDATE_STATUSA = struct__UPDATE_STATUSA;
pub const LPUPDATE_STATUSA = [*c]struct__UPDATE_STATUSA;
pub const UPDATE_STATUS = UPDATE_STATUSA;
pub const LPUPDATE_STATUS = LPUPDATE_STATUSA;
pub const struct__UPDATE_PARTITION_STATUSW = extern struct {
    percentage: UINT32 = @import("std").mem.zeroes(UINT32),
    updateInfo: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    currentStatus: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const UPDATE_PARTITION_STATUSW = struct__UPDATE_PARTITION_STATUSW;
pub const LPUPDATE_PARTITION_STATUSW = [*c]struct__UPDATE_PARTITION_STATUSW;
pub const struct__UPDATE_PARTITION_STATUSA = extern struct {
    percentage: UINT32 = @import("std").mem.zeroes(UINT32),
    updateInfo: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    currentStatus: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const UPDATE_PARTITION_STATUSA = struct__UPDATE_PARTITION_STATUSA;
pub const LPUPDATE_PARTITION_STATUSA = [*c]struct__UPDATE_PARTITION_STATUSA;
pub const UPDATE_PARTITION_STATUS = UPDATE_PARTITION_STATUSA;
pub const LPUPDATE_PARTITION_STATUS = LPUPDATE_PARTITION_STATUSA;
pub const struct__TIME_SERVER_INFOW = extern struct {
    sntpHostName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const TIME_SERVER_INFOW = struct__TIME_SERVER_INFOW;
pub const LPTIME_SERVER_INFOW = [*c]struct__TIME_SERVER_INFOW;
pub const struct__TIME_SERVER_INFOA = extern struct {
    sntpHostName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const TIME_SERVER_INFOA = struct__TIME_SERVER_INFOA;
pub const LPTIME_SERVER_INFOA = [*c]struct__TIME_SERVER_INFOA;
pub const TIME_SERVER_INFO = TIME_SERVER_INFOA;
pub const LPTIME_SERVER_INFO = LPTIME_SERVER_INFOA;
pub const struct__SYSLOG_SERVER_INFOW = extern struct {
    remoteServerHostName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    remoteServerPort: UINT32 = @import("std").mem.zeroes(UINT32),
    minSeverity: UINT16 = @import("std").mem.zeroes(UINT16),
};
pub const SYSLOG_SERVER_INFOW = struct__SYSLOG_SERVER_INFOW;
pub const LPSYSLOG_SERVER_INFOW = [*c]struct__SYSLOG_SERVER_INFOW;
pub const struct__SYSLOG_SERVER_INFOA = extern struct {
    remoteServerHostName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    remoteServerPort: UINT32 = @import("std").mem.zeroes(UINT32),
    minSeverity: UINT16 = @import("std").mem.zeroes(UINT16),
};
pub const SYSLOG_SERVER_INFOA = struct__SYSLOG_SERVER_INFOA;
pub const LPSYSLOG_SERVER_INFOA = [*c]struct__SYSLOG_SERVER_INFOA;
pub const struct__WIRELESS_CONFIGURED_PARAMETERSW = extern struct {
    essid: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    passKey: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    autoconnect: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
};
pub const WIRELESS_CONFIGURED_PARAMETERSW = struct__WIRELESS_CONFIGURED_PARAMETERSW;
pub const LPWIRELESS_CONFIGURED_PARAMETERSW = [*c]struct__WIRELESS_CONFIGURED_PARAMETERSW;
pub const struct__WIRELESS_CONFIGURED_PARAMETERSA = extern struct {
    essid: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    passKey: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    autoconnect: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
};
pub const WIRELESS_CONFIGURED_PARAMETERSA = struct__WIRELESS_CONFIGURED_PARAMETERSA;
pub const LPWIRELESS_CONFIGURED_PARAMETERSA = [*c]struct__WIRELESS_CONFIGURED_PARAMETERSA;
pub const SYSLOG_SERVER_INFO = SYSLOG_SERVER_INFOA;
pub const LPSYSLOG_SERVER_INFO = LPSYSLOG_SERVER_INFOA;
pub const WIRELESS_CONFIGURED_PARAMETERS = WIRELESS_CONFIGURED_PARAMETERSA;
pub const LPWIRELESS_CONFIGURED_PARAMETERS = LPWIRELESS_CONFIGURED_PARAMETERSA;
pub const struct__READER_INFOW = extern struct {
    name: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    description: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    location: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    contact: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    antennaCheck: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    reserved: [3]BOOLEAN = @import("std").mem.zeroes([3]BOOLEAN),
    lpTimeServerInfo: LPTIME_SERVER_INFOW = @import("std").mem.zeroes(LPTIME_SERVER_INFOW),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const READER_INFOW = struct__READER_INFOW;
pub const LPREADER_INFOW = [*c]struct__READER_INFOW;
pub const struct__READER_INFOA = extern struct {
    name: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    description: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    location: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    contact: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    antennaCheck: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    reserved: [3]BOOLEAN = @import("std").mem.zeroes([3]BOOLEAN),
    lpTimeServerInfo: LPTIME_SERVER_INFOA = @import("std").mem.zeroes(LPTIME_SERVER_INFOA),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const READER_INFOA = struct__READER_INFOA;
pub const LPREADER_INFOA = [*c]struct__READER_INFOA;
pub const READER_INFO = READER_INFOA;
pub const LPREADER_INFO = LPREADER_INFOA;
pub const struct__READER_NETWORK_INFOW = extern struct {
    IPAddress: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    MACAddress: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    SubnetMask: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    Gateway: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    DNSServer: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    IPVersion: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    IPV6Address: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    IPV6Suffix: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    IPV6DNS: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    IPV6GateWay: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    Interface: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    isDHCPEnabled: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    isCoreConfig: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    isDHCPv6Enabled: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    EnableRAPAckets: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const READER_NETWORK_INFOW = struct__READER_NETWORK_INFOW;
pub const LPREADER_NETWORK_INFOW = [*c]struct__READER_NETWORK_INFOW;
pub const struct__READER_DEVICE_INFOW = extern struct {
    hostName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    manufacturer: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    model: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    hardWareVersion: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    bootLoaderVersion: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    NumPhysicalAntennas: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const READER_DEVICE_INFOW = struct__READER_DEVICE_INFOW;
pub const LPREADER_DEVICE_INFOW = [*c]struct__READER_DEVICE_INFOW;
pub const struct__READER_SYSTEM_INFOW = extern struct {
    structInfo: _STRUCT_INFO = @import("std").mem.zeroes(_STRUCT_INFO),
    radioFirmwareVersion: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    fPGAVersion: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    upTime: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    readerName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    readerLocation: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    ramAvailable: UINT32 = @import("std").mem.zeroes(UINT32),
    flashAvailable: UINT32 = @import("std").mem.zeroes(UINT32),
    ramUsed: UINT32 = @import("std").mem.zeroes(UINT32),
    ramTotal: UINT32 = @import("std").mem.zeroes(UINT32),
    cpuUsageForUserProcesses: INT8 = @import("std").mem.zeroes(INT8),
    cpuUsageForSystemProcesses: INT8 = @import("std").mem.zeroes(INT8),
    reserved1: UINT16 = @import("std").mem.zeroes(UINT16),
    reserved32: [4]UINT32 = @import("std").mem.zeroes([4]UINT32),
    serialNumber: [*c]WCHAR = @import("std").mem.zeroes([*c]WCHAR),
    powerSource: POWER_SOURCE_TYPE = @import("std").mem.zeroes(POWER_SOURCE_TYPE),
    networkInfo: LPREADER_NETWORK_INFOW = @import("std").mem.zeroes(LPREADER_NETWORK_INFOW),
    deviceInfo: LPREADER_DEVICE_INFOW = @import("std").mem.zeroes(LPREADER_DEVICE_INFOW),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const READER_SYSTEM_INFOW = struct__READER_SYSTEM_INFOW;
pub const LPREADER_SYSTEM_INFOW = [*c]struct__READER_SYSTEM_INFOW;
pub const struct__READER_NETWORK_INFOA = extern struct {
    IPAddress: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    MACAddress: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    SubnetMask: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    Gateway: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    DNSServer: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    IPVersion: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    IPV6Address: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    IPV6Suffix: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    IPV6DNS: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    IPV6GateWay: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    Interface: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    isDHCPEnabled: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    isCoreConfig: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    isDHCPv6Enabled: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    EnableRAPAckets: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const READER_NETWORK_INFOA = struct__READER_NETWORK_INFOA;
pub const LPREADER_NETWORK_INFOA = [*c]struct__READER_NETWORK_INFOA;
pub const struct__READER_DEVICE_INFOA = extern struct {
    hostName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    manufacturer: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    model: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    hardWareVersion: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    bootLoaderVersion: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    numPhysicalAntennas: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const READER_DEVICE_INFOA = struct__READER_DEVICE_INFOA;
pub const LPREADER_DEVICE_INFOA = [*c]struct__READER_DEVICE_INFOA;
pub const struct__READER_SYSTEM_INFOA = extern struct {
    structInfo: _STRUCT_INFO = @import("std").mem.zeroes(_STRUCT_INFO),
    radioFirmwareVersion: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    fPGAVersion: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    upTime: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    readerName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    readerLocation: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    ramAvailable: UINT32 = @import("std").mem.zeroes(UINT32),
    flashAvailable: UINT32 = @import("std").mem.zeroes(UINT32),
    ramUsed: UINT32 = @import("std").mem.zeroes(UINT32),
    ramTotal: UINT32 = @import("std").mem.zeroes(UINT32),
    cpuUsageForUserProcesses: INT8 = @import("std").mem.zeroes(INT8),
    cpuUsageForSystemProcesses: INT8 = @import("std").mem.zeroes(INT8),
    reserved1: UINT16 = @import("std").mem.zeroes(UINT16),
    reserved32: [4]UINT32 = @import("std").mem.zeroes([4]UINT32),
    serialNumber: [*c]CHAR = @import("std").mem.zeroes([*c]CHAR),
    powerSource: POWER_SOURCE_TYPE = @import("std").mem.zeroes(POWER_SOURCE_TYPE),
    networkInfo: LPREADER_NETWORK_INFOA = @import("std").mem.zeroes(LPREADER_NETWORK_INFOA),
    deviceInfo: LPREADER_DEVICE_INFOA = @import("std").mem.zeroes(LPREADER_DEVICE_INFOA),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const READER_SYSTEM_INFOA = struct__READER_SYSTEM_INFOA;
pub const LPREADER_SYSTEM_INFOA = [*c]struct__READER_SYSTEM_INFOA;
pub const READER_SYSTEM_INFO = READER_SYSTEM_INFOA;
pub const LPREADER_SYSTEM_INFO = LPREADER_SYSTEM_INFOA;
pub const READER_NETWORK_INFO = READER_NETWORK_INFOA;
pub const LPREADER_NETWORK_INFO = LPREADER_NETWORK_INFOA;
pub const struct__PROFILE_LISTW = extern struct {
    numProfiles: UINT16 = @import("std").mem.zeroes(UINT16),
    pProfileName: [*c][*c]WCHAR = @import("std").mem.zeroes([*c][*c]WCHAR),
    activeProfileIndex: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [16]LPVOID = @import("std").mem.zeroes([16]LPVOID),
};
pub const PROFILE_LISTW = struct__PROFILE_LISTW;
pub const LPPROFILE_LISTW = [*c]struct__PROFILE_LISTW;
pub const struct__PROFILE_LISTA = extern struct {
    numProfiles: UINT16 = @import("std").mem.zeroes(UINT16),
    pProfileName: [*c][*c]CHAR = @import("std").mem.zeroes([*c][*c]CHAR),
    activeProfileIndex: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [16]LPVOID = @import("std").mem.zeroes([16]LPVOID),
};
pub const PROFILE_LISTA = struct__PROFILE_LISTA;
pub const LPPROFILE_LISTA = [*c]struct__PROFILE_LISTA;
pub const PROFILE_LIST = PROFILE_LISTA;
pub const LPPROFILE_LIST = LPPROFILE_LISTA;
pub const struct__LICENSE_INFOW = extern struct {
    index: UINT16 = @import("std").mem.zeroes(UINT16),
    szName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    szVersion: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    szExpiryDate: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    count: UINT16 = @import("std").mem.zeroes(UINT16),
    szHostID: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
};
pub const LICENSE_INFOW = struct__LICENSE_INFOW;
pub const LPLICENSE_INFOW = [*c]struct__LICENSE_INFOW;
pub const struct__LICENSE_INFOA = extern struct {
    index: UINT16 = @import("std").mem.zeroes(UINT16),
    szName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    szVersion: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    szExpiryDate: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    count: UINT16 = @import("std").mem.zeroes(UINT16),
    szHostID: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
};
pub const LICENSE_INFOA = struct__LICENSE_INFOA;
pub const LPLICENSE_INFOA = [*c]struct__LICENSE_INFOA;
pub const struct__LICENSE_LISTW = extern struct {
    numLicenses: UINT32 = @import("std").mem.zeroes(UINT32),
    pLicenseList: [*c]LICENSE_INFOW = @import("std").mem.zeroes([*c]LICENSE_INFOW),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const LICENSE_LISTW = struct__LICENSE_LISTW;
pub const LPLICENSE_LISTW = [*c]struct__LICENSE_LISTW;
pub const struct__LICENSE_LISTA = extern struct {
    numLicenses: UINT32 = @import("std").mem.zeroes(UINT32),
    pLicenseList: [*c]LICENSE_INFOA = @import("std").mem.zeroes([*c]LICENSE_INFOA),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const LICENSE_LISTA = struct__LICENSE_LISTA;
pub const LPLICENSE_LISTA = [*c]struct__LICENSE_LISTA;
pub const LICENSE_LIST = LICENSE_LISTA;
pub const LPLICENSE_LIST = LPLICENSE_LISTA;
pub const struct__TIME_ZONE_LISTW = extern struct {
    numTimeZones: UINT16 = @import("std").mem.zeroes(UINT16),
    pTimeZone: [*c][*c]WCHAR = @import("std").mem.zeroes([*c][*c]WCHAR),
    activeTimeZoneIndex: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const TIME_ZONE_LISTW = struct__TIME_ZONE_LISTW;
pub const LPTIME_ZONE_LISTW = [*c]struct__TIME_ZONE_LISTW;
pub const struct__TIME_ZONE_LISTA = extern struct {
    numTimeZones: UINT16 = @import("std").mem.zeroes(UINT16),
    pTimeZone: [*c][*c]CHAR = @import("std").mem.zeroes([*c][*c]CHAR),
    activeTimeZoneIndex: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const TIME_ZONE_LISTA = struct__TIME_ZONE_LISTA;
pub const LPTIME_ZONE_LISTA = [*c]struct__TIME_ZONE_LISTA;
pub const TIME_ZONE_LIST = TIME_ZONE_LISTA;
pub const LPTIME_ZONE_LIST = LPTIME_ZONE_LISTA;
pub const struct__FILE_UPDATE_LISTW = extern struct {
    numFiles: UINT16 = @import("std").mem.zeroes(UINT16),
    pFileName: [*c][*c]WCHAR = @import("std").mem.zeroes([*c][*c]WCHAR),
};
pub const FILE_UPDATE_LISTW = struct__FILE_UPDATE_LISTW;
pub const LPFILE_UPDATE_LISTW = [*c]struct__FILE_UPDATE_LISTW;
pub const struct__FILE_UPDATE_LISTA = extern struct {
    numFiles: UINT16 = @import("std").mem.zeroes(UINT16),
    pFileName: [*c][*c]CHAR = @import("std").mem.zeroes([*c][*c]CHAR),
};
pub const FILE_UPDATE_LISTA = struct__FILE_UPDATE_LISTA;
pub const LPFILE_UPDATE_LISTA = [*c]struct__FILE_UPDATE_LISTA;
pub const FILE_UPDATE_LIST = FILE_UPDATE_LISTA;
pub const LPFILE_UPDATE_LIST = LPFILE_UPDATE_LISTA;
pub const struct__SEC_LLRP_CONFIG = extern struct {
    secureMode: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    validatePeerCert: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const SEC_LLRP_CONFIG = struct__SEC_LLRP_CONFIG;
pub const LPSEC_LLRP_CONFIG = [*c]struct__SEC_LLRP_CONFIG;
pub const struct__LLRP_CONNECTION_STATUSW = extern struct {
    isConnected: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    clientIPAddress: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const LLRP_CONNECTION_STATUSW = struct__LLRP_CONNECTION_STATUSW;
pub const LPLLRP_CONNECTION_STATUSW = [*c]struct__LLRP_CONNECTION_STATUSW;
pub const struct__LLRP_CONNECTION_STATUSA = extern struct {
    isConnected: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    clientIPAddress: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const LLRP_CONNECTION_STATUSA = struct__LLRP_CONNECTION_STATUSA;
pub const LPLLRP_CONNECTION_STATUSA = [*c]struct__LLRP_CONNECTION_STATUSA;
pub const struct__LLRP_CONNECTION_CONFIGW = extern struct {
    isClient: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    port: UINT32 = @import("std").mem.zeroes(UINT32),
    hostServerIP: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    pSecureModeConfig: LPSEC_LLRP_CONFIG = @import("std").mem.zeroes(LPSEC_LLRP_CONFIG),
    lpReserved: [5]LPVOID = @import("std").mem.zeroes([5]LPVOID),
};
pub const LLRP_CONNECTION_CONFIGW = struct__LLRP_CONNECTION_CONFIGW;
pub const LPLLRP_CONNECTION_CONFIGW = [*c]struct__LLRP_CONNECTION_CONFIGW;
pub const struct__LLRP_CONNECTION_CONFIGA = extern struct {
    isClient: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    port: UINT32 = @import("std").mem.zeroes(UINT32),
    hostServerIP: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    pSecureModeConfig: LPSEC_LLRP_CONFIG = @import("std").mem.zeroes(LPSEC_LLRP_CONFIG),
    lpReserved: [5]LPVOID = @import("std").mem.zeroes([5]LPVOID),
};
pub const LLRP_CONNECTION_CONFIGA = struct__LLRP_CONNECTION_CONFIGA;
pub const LPLLRP_CONNECTION_CONFIGA = [*c]struct__LLRP_CONNECTION_CONFIGA;
pub const LLRP_CONNECTION_CONFIG = LLRP_CONNECTION_CONFIGA;
pub const LPLLRP_CONNECTION_CONFIG = LPLLRP_CONNECTION_CONFIGA;
pub const LLRP_CONNECTION_STATUS = LLRP_CONNECTION_STATUSA;
pub const LPLLRP_CONNECTION_STATUS = LPLLRP_CONNECTION_STATUSA;
pub const struct__USB_OPERATION_INFO = extern struct {
    mode: USB_OPERATION_MODE = @import("std").mem.zeroes(USB_OPERATION_MODE),
    allowLLRPConnectionOverride: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const USB_OPERATION_INFO = struct__USB_OPERATION_INFO;
pub const LPUSB_OPERATION_INFO = [*c]struct__USB_OPERATION_INFO;
pub const struct__LED_INFO = extern struct {
    ledColor: LED_COLOR = @import("std").mem.zeroes(LED_COLOR),
    durationSeconds: UINT32 = @import("std").mem.zeroes(UINT32),
    blink: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const LED_INFO = struct__LED_INFO;
pub const LPLED_INFO = [*c]struct__LED_INFO;
pub const struct__ERROR_INFOW = extern struct {
    errorTimeStamp: SYSTEMTIME = @import("std").mem.zeroes(SYSTEMTIME),
    rfidStatusCode: RFID_STATUS = @import("std").mem.zeroes(RFID_STATUS),
    statusDesc: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    vendorMessage: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
};
pub const ERROR_INFOW = struct__ERROR_INFOW;
pub const LPERROR_INFOW = [*c]struct__ERROR_INFOW;
pub const struct__ERROR_INFOA = extern struct {
    errorTimeStamp: SYSTEMTIME = @import("std").mem.zeroes(SYSTEMTIME),
    rfidStatusCode: RFID_STATUS = @import("std").mem.zeroes(RFID_STATUS),
    statusDesc: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    vendorMessage: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
};
pub const ERROR_INFOA = struct__ERROR_INFOA;
pub const LPERROR_INFOA = [*c]struct__ERROR_INFOA;
pub const ERROR_INFO = ERROR_INFOA;
pub const LPERROR_INFO = LPERROR_INFOA;
pub const struct__NXP_SET_EAS_PARAMS = extern struct {
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    EASState: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const NXP_SET_EAS_PARAMS = struct__NXP_SET_EAS_PARAMS;
pub const LPNXP_SET_EAS_PARAMS = [*c]struct__NXP_SET_EAS_PARAMS;
pub const struct__NXP_READ_PROTECT_PARAMS = extern struct {
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const NXP_READ_PROTECT_PARAMS = struct__NXP_READ_PROTECT_PARAMS;
pub const LPNXP_READ_PROTECT_PARAMS = [*c]struct__NXP_READ_PROTECT_PARAMS;
pub const struct__NXP_RESET_READ_PROTECT_PARAMS = extern struct {
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const NXP_RESET_READ_PROTECT_PARAMS = struct__NXP_RESET_READ_PROTECT_PARAMS;
pub const LPNXP_RESET_READ_PROTECT_PARAMS = [*c]struct__NXP_RESET_READ_PROTECT_PARAMS;
pub const struct__FUJITSU_CHANGE_WORDLOCK_ACCESS_PARAMS = extern struct {
    memoryBankName: MEMORY_BANK = @import("std").mem.zeroes(MEMORY_BANK),
    byteOffset: UINT16 = @import("std").mem.zeroes(UINT16),
    payloadAction: UINT8 = @import("std").mem.zeroes(UINT8),
    payloadMask: UINT8 = @import("std").mem.zeroes(UINT8),
    blockGroupPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const FUJITSU_CHANGE_WORDLOCK_ACCESS_PARAMS = struct__FUJITSU_CHANGE_WORDLOCK_ACCESS_PARAMS;
pub const LPFUJITSU_CHANGE_WORDLOCK_ACCESS_PARAMS = [*c]struct__FUJITSU_CHANGE_WORDLOCK_ACCESS_PARAMS;
pub const struct__FUJITSU_CHANGE_BLOCKLOCK_ACCESS_PARAMS = extern struct {
    blockGroupOffset: UINT8 = @import("std").mem.zeroes(UINT8),
    payloadAction: UINT16 = @import("std").mem.zeroes(UINT16),
    payloadMask: UINT16 = @import("std").mem.zeroes(UINT16),
    blockGroupPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const FUJITSU_CHANGE_BLOCKLOCK_ACCESS_PARAMS = struct__FUJITSU_CHANGE_BLOCKLOCK_ACCESS_PARAMS;
pub const LPFUJITSU_CHANGE_BLOCKLOCK_ACCESS_PARAMS = [*c]struct__FUJITSU_CHANGE_BLOCKLOCK_ACCESS_PARAMS;
pub const struct__FUJITSU_READ_BLOCKLOCK_ACCESS_PARAMS = extern struct {
    blockGroupOffset: UINT8 = @import("std").mem.zeroes(UINT8),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const FUJITSU_READ_BLOCKLOCK_ACCESS_PARAMS = struct__FUJITSU_READ_BLOCKLOCK_ACCESS_PARAMS;
pub const LPFUJITSU_READ_BLOCKLOCK_ACCESS_PARAMS = [*c]struct__FUJITSU_READ_BLOCKLOCK_ACCESS_PARAMS;
pub const struct__FUJITSU_BURST_WRITE_ACCESS_PARAMS = extern struct {
    memoryBank: MEMORY_BANK = @import("std").mem.zeroes(MEMORY_BANK),
    byteOffset: UINT16 = @import("std").mem.zeroes(UINT16),
    pBurstWriteData: [*c]UINT8 = @import("std").mem.zeroes([*c]UINT8),
    burstWriteDataLength: UINT16 = @import("std").mem.zeroes(UINT16),
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const FUJITSU_BURST_WRITE_ACCESS_PARAMS = struct__FUJITSU_BURST_WRITE_ACCESS_PARAMS;
pub const LPFUJITSU_BURST_WRITE_ACCESS_PARAMS = [*c]struct__FUJITSU_BURST_WRITE_ACCESS_PARAMS;
pub const struct__FUJITSU_BURSTERASE_ACCESS_PARAMS = extern struct {
    memoryBank: MEMORY_BANK = @import("std").mem.zeroes(MEMORY_BANK),
    byteOffset: UINT16 = @import("std").mem.zeroes(UINT16),
    burstEraseLength: UINT16 = @import("std").mem.zeroes(UINT16),
    accessPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const FUJITSU_BURST_ERASE_ACCESS_PARAMS = struct__FUJITSU_BURSTERASE_ACCESS_PARAMS;
pub const LPFUJITSU_BURST_ERASE_ACCESS_PARAMS = [*c]struct__FUJITSU_BURSTERASE_ACCESS_PARAMS;
pub const struct__FUJITSU_AREA_READLOCK_ACCESS_PARAMS = extern struct {
    areaGroupOffset: UINT8 = @import("std").mem.zeroes(UINT8),
    payloadAction: UINT16 = @import("std").mem.zeroes(UINT16),
    payloadMask: UINT16 = @import("std").mem.zeroes(UINT16),
    areaGroupPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const FUJITSU_AREA_READLOCK_ACCESS_PARAMS = struct__FUJITSU_AREA_READLOCK_ACCESS_PARAMS;
pub const LPFUJITSU_AREA_READLOCK_ACCESS_PARAMS = [*c]struct__FUJITSU_AREA_READLOCK_ACCESS_PARAMS;
pub const struct__FUJITSU_AREA_WRITELOCK_ACCESS_PARAMS = extern struct {
    areaGroupOffset: UINT8 = @import("std").mem.zeroes(UINT8),
    payloadAction: UINT16 = @import("std").mem.zeroes(UINT16),
    payloadMask: UINT16 = @import("std").mem.zeroes(UINT16),
    areaGroupPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const FUJITSU_AREA_WRITELOCK_ACCESS_PARAMS = struct__FUJITSU_AREA_WRITELOCK_ACCESS_PARAMS;
pub const LPFUJITSU_AREA_WRITELOCK_ACCESS_PARAMS = [*c]struct__FUJITSU_AREA_WRITELOCK_ACCESS_PARAMS;
pub const struct__FUJITSU_AREA_WRITELOCK_WOPASSWORD_ACCESS_PARAMS = extern struct {
    areaGroupOffset: UINT8 = @import("std").mem.zeroes(UINT8),
    payloadAction: UINT16 = @import("std").mem.zeroes(UINT16),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const FUJITSU_AREA_WRITELOCK_WOPASSWORD_ACCESS_PARAMS = struct__FUJITSU_AREA_WRITELOCK_WOPASSWORD_ACCESS_PARAMS;
pub const LPFUJITSU_AREA_WRITELOCK_WOPASSWORD_ACCESS_PARAMS = [*c]struct__FUJITSU_AREA_WRITELOCK_WOPASSWORD_ACCESS_PARAMS;
pub const struct__FUJITSU_CHANGE_BLOCK_OR_AREA_GROUPPASSWORD_ACCESS_PARAMS = extern struct {
    blockOrAreaGroupOffset: UINT8 = @import("std").mem.zeroes(UINT8),
    newPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    currentPassword: UINT32 = @import("std").mem.zeroes(UINT32),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const FUJITSU_CHANGE_BLOCK_OR_AREA_GROUPPASSWORD_ACCESS_PARAMS = struct__FUJITSU_CHANGE_BLOCK_OR_AREA_GROUPPASSWORD_ACCESS_PARAMS;
pub const LPFUJITSU_CHANGE_BLOCK_OR_AREA_GROUPPASSWORD_ACCESS_PARAMS = [*c]struct__FUJITSU_CHANGE_BLOCK_OR_AREA_GROUPPASSWORD_ACCESS_PARAMS;
pub const struct__USERAPP_DATAW = extern struct {
    pAppName: [*c]WCHAR = @import("std").mem.zeroes([*c]WCHAR),
    runStatus: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    autoStart: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    pMetaData: [*c]WCHAR = @import("std").mem.zeroes([*c]WCHAR),
};
pub const USERAPP_DATAW = struct__USERAPP_DATAW;
pub const LPUSERAPP_DATAW = [*c]struct__USERAPP_DATAW;
pub const struct__USERAPP_LISTW = extern struct {
    numMaxApps: UINT32 = @import("std").mem.zeroes(UINT32),
    pUserAppData: [*c]USERAPP_DATAW = @import("std").mem.zeroes([*c]USERAPP_DATAW),
};
pub const USERAPP_LISTW = struct__USERAPP_LISTW;
pub const LPUSERAPP_LISTW = [*c]struct__USERAPP_LISTW;
pub const struct__USERAPP_DATAA = extern struct {
    pAppName: [*c]CHAR = @import("std").mem.zeroes([*c]CHAR),
    runStatus: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    autoStart: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    pMetaData: [*c]CHAR = @import("std").mem.zeroes([*c]CHAR),
};
pub const USERAPP_DATAA = struct__USERAPP_DATAA;
pub const LPUSERAPP_DATAA = [*c]struct__USERAPP_DATAA;
pub const struct__USERAPP_LISTA = extern struct {
    numMaxApps: UINT32 = @import("std").mem.zeroes(UINT32),
    pUserAppData: [*c]USERAPP_DATAA = @import("std").mem.zeroes([*c]USERAPP_DATAA),
};
pub const USERAPP_LISTA = struct__USERAPP_LISTA;
pub const LPUSERAPP_LISTA = [*c]struct__USERAPP_LISTA;
pub const LPUSERAPP_LIST = LPUSERAPP_LISTA;
pub const USERAPP_LIST = USERAPP_LISTA;
pub const struct__CABLE_LOSS_COMPENSATION_ = extern struct {
    antennaID: UINT16 = @import("std").mem.zeroes(UINT16),
    cableLengthInFt: FLOAT = @import("std").mem.zeroes(FLOAT),
    cableLossPer100Ft: FLOAT = @import("std").mem.zeroes(FLOAT),
};
pub const CABLE_LOSS_COMPENSATION = struct__CABLE_LOSS_COMPENSATION_;
pub const LPCABLE_LOSS_COMPENSATION = [*c]struct__CABLE_LOSS_COMPENSATION_;
pub const struct__SLED_BATTERY_STATUS = extern struct {
    batteryLevel: UINT32 = @import("std").mem.zeroes(UINT32),
    status: BATTERY_STATUS = @import("std").mem.zeroes(BATTERY_STATUS),
    lpReserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const SLED_BATTERY_STATUS = struct__SLED_BATTERY_STATUS;
pub const LPSLED_BATTERY_STATUS = [*c]struct__SLED_BATTERY_STATUS;
pub const struct__STANDARD_REGION_INFOW = extern struct {
    strRegionName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    strStandardName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    bIsHoppingConfigurable: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    iNumChannels: UINT32 = @import("std").mem.zeroes(UINT32),
    piChannelInfo: [*c]UINT32 = @import("std").mem.zeroes([*c]UINT32),
    piChannelValueInfo: [*c]UINT32 = @import("std").mem.zeroes([*c]UINT32),
};
pub const STANDARD_REGION_INFOW = struct__STANDARD_REGION_INFOW;
pub const LPSTANDARD_REGION_INFOW = [*c]struct__STANDARD_REGION_INFOW;
pub const struct__STANDARD_REGION_INFOA = extern struct {
    strRegionName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    strStandardName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    bIsHoppingConfigurable: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    iNumChannels: UINT32 = @import("std").mem.zeroes(UINT32),
    piChannelInfo: [*c]UINT32 = @import("std").mem.zeroes([*c]UINT32),
    piChannelValueInfo: [*c]UINT32 = @import("std").mem.zeroes([*c]UINT32),
};
pub const STANDARD_REGION_INFOA = struct__STANDARD_REGION_INFOA;
pub const LPSTANDARD_REGION_INFOA = [*c]struct__STANDARD_REGION_INFOA;
pub const struct__USER_INFOW = extern struct {
    userName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    oldPassword: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    newPassword: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const USER_INFOW = struct__USER_INFOW;
pub const LPUSER_INFOW = [*c]struct__USER_INFOW;
pub const struct__USER_INFOA = extern struct {
    userName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    oldPassword: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    newPassword: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const USER_INFOA = struct__USER_INFOA;
pub const LPUSER_INFOA = [*c]struct__USER_INFOA;
pub const struct__ACTIVE_REGION_INFOW = extern struct {
    strRegionName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    strStandardName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    bIsHoppingOn: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    iNumChannels: UINT32 = @import("std").mem.zeroes(UINT32),
    piChannelInfo: [*c]UINT32 = @import("std").mem.zeroes([*c]UINT32),
};
pub const ACTIVE_REGION_INFOW = struct__ACTIVE_REGION_INFOW;
pub const LPACTIVE_REGION_INFOW = [*c]struct__ACTIVE_REGION_INFOW;
pub const struct__ACTIVE_REGION_INFOA = extern struct {
    strRegionName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    strStandardName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    bIsHoppingOn: BOOLEAN = @import("std").mem.zeroes(BOOLEAN),
    iNumChannels: UINT32 = @import("std").mem.zeroes(UINT32),
    piChannelInfo: [*c]UINT32 = @import("std").mem.zeroes([*c]UINT32),
};
pub const ACTIVE_REGION_INFOA = struct__ACTIVE_REGION_INFOA;
pub const LPACTIVE_REGION_INFOA = [*c]struct__ACTIVE_REGION_INFOA;
pub const struct__REGION_LISTW = extern struct {
    numRegions: UINT32 = @import("std").mem.zeroes(UINT32),
    RegionNamesList: [*c][*c]WCHAR = @import("std").mem.zeroes([*c][*c]WCHAR),
};
pub const REGION_LISTW = struct__REGION_LISTW;
pub const LPREGION_LISTW = [*c]struct__REGION_LISTW;
pub const struct__REGION_LISTA = extern struct {
    numRegions: UINT32 = @import("std").mem.zeroes(UINT32),
    RegionNamesList: [*c][*c]CHAR = @import("std").mem.zeroes([*c][*c]CHAR),
};
pub const REGION_LISTA = struct__REGION_LISTA;
pub const LPREGION_LISTA = [*c]struct__REGION_LISTA;
pub const struct__STANDARD_INFO_LISTW = extern struct {
    numStds: UINT32 = @import("std").mem.zeroes(UINT32),
    StdsList: [*c]STANDARD_REGION_INFOW = @import("std").mem.zeroes([*c]STANDARD_REGION_INFOW),
};
pub const STANDARD_INFO_LISTW = struct__STANDARD_INFO_LISTW;
pub const LPSTANDARD_INFO_LISTW = [*c]struct__STANDARD_INFO_LISTW;
pub const struct__STANDARD_INFO_LISTA = extern struct {
    numStds: UINT32 = @import("std").mem.zeroes(UINT32),
    StdsList: [*c]STANDARD_REGION_INFOA = @import("std").mem.zeroes([*c]STANDARD_REGION_INFOA),
};
pub const STANDARD_INFO_LISTA = struct__STANDARD_INFO_LISTA;
pub const LPSTANDARD_INFO_LISTA = [*c]struct__STANDARD_INFO_LISTA;
pub const struct__CHANNEL_LIST = extern struct {
    iNumChannels: UINT32 = @import("std").mem.zeroes(UINT32),
    ChannelList: [*c]UINT32 = @import("std").mem.zeroes([*c]UINT32),
};
pub const CHANNEL_LIST = struct__CHANNEL_LIST;
pub const LPCHANNEL_LIST = [*c]struct__CHANNEL_LIST;
pub const struct__TEMPERATURE_STATUS_W = extern struct {
    paTemp: FLOAT = @import("std").mem.zeroes(FLOAT),
    ambientTemp: FLOAT = @import("std").mem.zeroes(FLOAT),
};
pub const TEMPERATURE_STATUSW = struct__TEMPERATURE_STATUS_W;
pub const LPTEMPERATURE_STATUSW = [*c]struct__TEMPERATURE_STATUS_W;
pub const struct__TEMPERATURE_STATUS_A = extern struct {
    paTemp: FLOAT = @import("std").mem.zeroes(FLOAT),
    ambientTemp: FLOAT = @import("std").mem.zeroes(FLOAT),
};
pub const TEMPERATURE_STATUSA = struct__TEMPERATURE_STATUS_A;
pub const LPTEMPERATURE_STATUSA = [*c]struct__TEMPERATURE_STATUS_A;
pub const STANDARD_REGION_INFO = STANDARD_REGION_INFOA;
pub const LPSTANDARD_REGION_INFO = LPSTANDARD_REGION_INFOA;
pub const ACTIVE_REGION_INFO = ACTIVE_REGION_INFOA;
pub const LPACTIVE_REGION_INFO = LPACTIVE_REGION_INFOA;
pub const REGION_LIST = REGION_LISTA;
pub const LPREGION_LIST = LPREGION_LISTA;
pub const STANDARD_INFO_LIST = STANDARD_INFO_LISTA;
pub const LPSTANDARD_INFO_LIST = LPSTANDARD_INFO_LISTA;
pub const USER_INFO = USER_INFOA;
pub const LPTEMPERATURE_STATUS = LPTEMPERATURE_STATUSA;
pub const struct__IOT_CLOUD_INFOW = extern struct {
    iotCloudEndpointAddr: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    iotCloudDeviceToken: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    iotCloudProtocol: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const IOT_CLOUD_INFOW = struct__IOT_CLOUD_INFOW;
pub const LPIOT_CLOUD_INFOW = [*c]struct__IOT_CLOUD_INFOW;
pub const struct__IOT_CLOUD_INFOA = extern struct {
    iotCloudEndpointAddr: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    iotCloudDeviceToken: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    iotCloudProtocol: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    lpReserved: [4]LPVOID = @import("std").mem.zeroes([4]LPVOID),
};
pub const IOT_CLOUD_INFOA = struct__IOT_CLOUD_INFOA;
pub const LPIOT_CLOUD_INFOA = [*c]struct__IOT_CLOUD_INFOA;
pub const IOT_CLOUD_INFO = IOT_CLOUD_INFOA;
pub const LPIOT_CLOUD_INFO = LPIOT_CLOUD_INFOA;
pub const struct__SMART_ALGORITHM_PARAMS = extern struct {
    SMARTAlgorithmSelector: SMART_ALGORITHM_SELECTOR = @import("std").mem.zeroes(SMART_ALGORITHM_SELECTOR),
    reserved: [2]LPVOID = @import("std").mem.zeroes([2]LPVOID),
};
pub const SMART_ALGORITHM_PARAMS = struct__SMART_ALGORITHM_PARAMS;
pub const LPSMART_ALGORITHM_PARAMS = [*c]struct__SMART_ALGORITHM_PARAMS;
pub extern fn RFID_ConnectW(pReaderHandle: [*c]RFID_HANDLE32, pHostName: [*c]WCHAR, port: UINT32, timeoutMilliseconds: UINT32, lpConnectionInfo: LPCONNECTION_INFO) RFID_STATUS;
pub extern fn RFID_ConnectA(pReaderHandle: [*c]RFID_HANDLE32, pHostName: [*c]CHAR, port: UINT32, timeoutMilliseconds: UINT32, lpConnectionInfo: LPCONNECTION_INFO) RFID_STATUS;
pub extern fn RFID_Reconnect(readerHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_AcceptConnection(pReaderHandle: [*c]RFID_HANDLE32, readerSocket: SOCKET_HANDLE, lpServerInfo: LPSERVER_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_Disconnect(readerHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_GetDllVersionInfoW(lpVersionInfo: LPVERSION_INFOW) RFID_STATUS;
pub extern fn RFID_GetDllVersionInfoA(lpVersionInfo: LPVERSION_INFOA) RFID_STATUS;
pub extern fn RFID_GetReaderCapsW(readerHandle: RFID_HANDLE32, lpReaderCaps: LPREADER_CAPSW) RFID_STATUS;
pub extern fn RFID_GetReaderCapsA(readerHandle: RFID_HANDLE32, lpReaderCaps: LPREADER_CAPSA) RFID_STATUS;
pub extern fn RFID_GetSledBatteryStatus(readerHandle: RFID_HANDLE32, lpSledBatteryStatus: LPSLED_BATTERY_STATUS) RFID_STATUS;
pub extern fn RFID_GetAntennaConfig(readerHandle: RFID_HANDLE32, antennaID: UINT16, pReceiveSensitivityIndex: [*c]UINT16, pTransmitPowerIndex: [*c]UINT16, pTransmitFrequencyIndex: [*c]UINT16) RFID_STATUS;
pub extern fn RFID_SetAntennaConfig(readerHandle: RFID_HANDLE32, antennaID: UINT16, receiveSensitivityIndex: UINT16, transmitPowerIndex: UINT16, transmitFrequencyIndex: UINT16) RFID_STATUS;
pub extern fn RFID_SetAntennaRfConfig(readerHandle: RFID_HANDLE32, antennaID: UINT16, lpAntennaRfConfig: LPANTENNA_RF_CONFIG) RFID_STATUS;
pub extern fn RFID_GetAntennaRfConfig(readerHandle: RFID_HANDLE32, antennaID: UINT16, lpAntennaRfConfig: LPANTENNA_RF_CONFIG) RFID_STATUS;
pub extern fn RFID_GetPhysicalAntennaProperties(readerHandle: RFID_HANDLE32, antennaID: UINT16, pStatus: [*c]BOOLEAN, pAntennaGain: [*c]UINT32) RFID_STATUS;
pub extern fn RFID_ResetConfigToFactoryDefaults(readerHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_SaveLlrpConfig(readerHandle: RFID_HANDLE32, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_GetSaveLlrpConfigStatus(readerHandle: RFID_HANDLE32, pSaveStatus: [*c]BOOLEAN) RFID_STATUS;
pub extern fn RFID_SetGPOState(readerHandle: RFID_HANDLE32, portNumber: UINT32, gpoState: BOOLEAN) RFID_STATUS;
pub extern fn RFID_GetGPOState(readerHandle: RFID_HANDLE32, portNumber: UINT32, pGPOState: [*c]BOOLEAN) RFID_STATUS;
pub extern fn RFID_GetGPIState(readerHandle: RFID_HANDLE32, portNumber: UINT32, pGPIEnable: [*c]BOOLEAN, pState: [*c]GPI_PORT_STATE) RFID_STATUS;
pub extern fn RFID_EnableGPIPort(readerHandle: RFID_HANDLE32, portNumber: UINT32, gpiEnable: BOOLEAN) RFID_STATUS;
pub extern fn RFID_GetSingulationControl(readerHandle: RFID_HANDLE32, antennaID: UINT16, lpSingulationControl: LPSINGULATION_CONTROL) RFID_STATUS;
pub extern fn RFID_SetSingulationControl(readerHandle: RFID_HANDLE32, antennaID: UINT16, lpSingulationControl: LPSINGULATION_CONTROL) RFID_STATUS;
pub extern fn RFID_GetRFMode(readerHandle: RFID_HANDLE32, antennaID: UINT16, pRfModeTableIndex: [*c]UINT32, pTari: [*c]UINT32) RFID_STATUS;
pub extern fn RFID_SetRFMode(readerHandle: RFID_HANDLE32, antennaID: UINT16, rfModeTableIndex: UINT32, tari: UINT32) RFID_STATUS;
pub extern fn RFID_GetRadioPowerState(readerHandle: RFID_HANDLE32, pPowerState: [*c]BOOLEAN) RFID_STATUS;
pub extern fn RFID_SetRadioPowerState(readerHandle: RFID_HANDLE32, powerState: BOOLEAN) RFID_STATUS;
pub extern fn RFID_GetDutyCycle(readerHandle: RFID_HANDLE32, pDutyCycleIndex: [*c]UINT16, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_SetDutyCycle(readerHandle: RFID_HANDLE32, dutyCycleIndex: UINT16, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_RegisterEventNotification(readerHandle: RFID_HANDLE32, eventType: RFID_EVENT_TYPE, notifyObject: EVENT_HANDLE) RFID_STATUS;
pub const RfidEventCallbackFunction = ?*const fn (RFID_HANDLE32, RFID_EVENT_TYPE) callconv(.c) void;
pub extern fn RFID_RegisterEventNotificationCallback(readerHandle: RFID_HANDLE32, pEvents: [*c]RFID_EVENT_TYPE, numEvents: UINT32, pFnRfidEventCallbackFunction: RfidEventCallbackFunction, rsvd1: LPVOID, rsvd2: LPVOID) RFID_STATUS;
pub extern fn RFID_SetEventNotificationParams(readerHandle: RFID_HANDLE32, eventType: RFID_EVENT_TYPE, pEventParams: STRUCT_HANDLE) RFID_STATUS;
pub extern fn RFID_DeregisterEventNotification(readerHandle: RFID_HANDLE32, eventType: RFID_EVENT_TYPE) RFID_STATUS;
pub extern fn RFID_GetEventData(readerHandle: RFID_HANDLE32, eventType: RFID_EVENT_TYPE, pEventData: STRUCT_HANDLE) RFID_STATUS;
pub extern fn RFID_AddPreFilter(readerHandle: RFID_HANDLE32, antennaID: UINT16, lpPreFilter: LPPRE_FILTER, pFilterIndex: [*c]UINT32) RFID_STATUS;
pub extern fn RFID_DeletePreFilter(readerHandle: RFID_HANDLE32, antennaID: UINT16, filterIndex: UINT32) RFID_STATUS;
pub extern fn RFID_GetTagStorageSettings(readerHandle: RFID_HANDLE32, lpTagStorageSettings: LPTAG_STORAGE_SETTINGS) RFID_STATUS;
pub extern fn RFID_SetTagStorageSettings(readerHandle: RFID_HANDLE32, lpTagStorageSettings: LPTAG_STORAGE_SETTINGS) RFID_STATUS;
pub extern fn RFID_AllocateTag(readerHandle: RFID_HANDLE32) LPTAG_DATA;
pub extern fn RFID_DeallocateTag(readerHandle: RFID_HANDLE32, lpTagData: LPTAG_DATA) RFID_STATUS;
pub extern fn RFID_NXPBrandCheck(readerHandle: RFID_HANDLE32, lpPostFilter: LPPOST_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTriggerInfo: LPTRIGGER_INFO, brandID: UINT16) RFID_STATUS;
pub extern fn RFID_NXPStopBrandCheck(readerHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_PerformInventory(readerHandle: RFID_HANDLE32, lpPostFilter: LPPOST_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTriggerInfo: LPTRIGGER_INFO, lpSmartAlgorithmParams: LPSMART_ALGORITHM_PARAMS) RFID_STATUS;
pub extern fn RFID_StopInventory(readerHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_AllocateRFSurvey(readerHandle: RFID_HANDLE32) LPRFSURVEY_DATA;
pub extern fn RFID_DeallocateRFSurvey(readerHandle: RFID_HANDLE32, pRFSurveyData: LPRFSURVEY_DATA) RFID_STATUS;
pub extern fn RFID_StartRFSurvey(readerHandle: RFID_HANDLE32, antennaID: UINT16, lpRfSurveyStopTriggerInfo: LPRFSURVEY_STOP_TRIGGER, startFrequency: UINT32, endFrequency: UINT32, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_StopRFSurvey(readerHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_GetRFSurvey(readerHandle: RFID_HANDLE32, lpRFSurveyData: LPRFSURVEY_DATA) RFID_STATUS;
pub extern fn RFID_PerformTagLocationing(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID, rsvd1: LPVOID) RFID_STATUS;
pub extern fn RFID_StopTagLocationing(readerHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_PerformZoneInventory(readerHandle: RFID_HANDLE32, lpPostFilter: LPPOST_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTriggerInfo: LPTRIGGER_INFO, lpZoneSequence: LPZONE_SEQUENCE, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_AddZoneW(readerHandle: RFID_HANDLE32, zoneId: UINT16, zoneConfig: LPZONE_CONFIGW, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_AddZoneA(readerHandle: RFID_HANDLE32, zoneId: UINT16, zoneConfig: LPZONE_CONFIGA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_DeleteZone(readerHandle: RFID_HANDLE32, zoneId: UINT32, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_GetReadTag(readerHandle: RFID_HANDLE32, lpTagData: LPTAG_DATA) RFID_STATUS;
pub extern fn RFID_PurgeTags(readerHandle: RFID_HANDLE32, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_Read(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpReadAccessParams: LPREAD_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTagData: LPTAG_DATA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_Write(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpWriteAccessParams: LPWRITE_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_WriteTagID(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpWriteSpecificFieldAccessParams: LPWRITE_SPECIFIC_FIELD_ACCESS_PARAMS, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_WriteKillPassword(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpWriteSpecificFieldAccessParams: LPWRITE_SPECIFIC_FIELD_ACCESS_PARAMS, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_WriteAccessPassword(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpWriteSpecificFieldAccessParams: LPWRITE_SPECIFIC_FIELD_ACCESS_PARAMS, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_Kill(readerHandle: RFID_HANDLE32, pTagData: [*c]UINT8, tagDataLength: UINT32, lpKillParams: LPKILL_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_Lock(readerHandle: RFID_HANDLE32, pTagData: [*c]UINT8, tagDataLength: UINT32, lpLockAccessParams: LPLOCK_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_BlockWrite(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpWriteAccessParams: LPWRITE_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_BlockErase(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpBlkEraseAccessParams: LPBLOCK_ERASE_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_Recommission(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpRecommissionParams: LPRECOMMISSION_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_BlockPermalock(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpBlkPermalockAccessParams: LPBLOCK_PERMALOCK_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTagData: LPTAG_DATA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_Authenticate(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpAuthenticateAccessParams: LPAUTHENTICATE_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTagData: LPTAG_DATA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_ReadBuffer(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpReadBufferAccessParams: LPREADBUFFER_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTagData: LPTAG_DATA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_Untraceable(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpUntraceableAccessParams: LPUNTRACEABLE_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTagData: LPTAG_DATA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_Crypto(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpCryptoAccessParams: LPCRYPTO_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTagData: LPTAG_DATA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_InitializeAccessSequence(readerHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_AddOperationToAccessSequence(readerHandle: RFID_HANDLE32, lpOpCodeParams: LPOP_CODE_PARAMS, pOpCodeIndex: [*c]UINT32) RFID_STATUS;
pub extern fn RFID_DeleteOperationFromAccessSequence(readerHandle: RFID_HANDLE32, opCodeIndex: UINT32) RFID_STATUS;
pub extern fn RFID_DeinitializeAccessSequence(readerHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_PerformAccessSequence(readerHandle: RFID_HANDLE32, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTriggerInfo: LPTRIGGER_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_StopAccessSequence(readerHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_GetLastAccessResult(readerHandle: RFID_HANDLE32, pSuccessCount: [*c]UINT32, pFailureCount: [*c]UINT32) RFID_STATUS;
pub extern fn RFID_GetCustomParamsW(readerHandle: RFID_HANDLE32, paramType: RFID_PARAM_TYPE, pBuffer: [*c]WCHAR) RFID_STATUS;
pub extern fn RFID_GetCustomParamsA(readerHandle: RFID_HANDLE32, paramType: RFID_PARAM_TYPE, pBuffer: [*c]CHAR) RFID_STATUS;
pub extern fn RFID_SetCustomParamsW(readerHandle: RFID_HANDLE32, paramType: RFID_PARAM_TYPE, pBuffer: [*c]WCHAR) RFID_STATUS;
pub extern fn RFID_SetCustomParamsA(readerHandle: RFID_HANDLE32, paramType: RFID_PARAM_TYPE, pBuffer: [*c]CHAR) RFID_STATUS;
pub extern fn RFID_NXPSetEAS(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpNXPSetEASParams: LPNXP_SET_EAS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_NXPReadProtect(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpNXPReadProtectParams: LPNXP_READ_PROTECT_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_NXPResetReadProtect(readerHandle: RFID_HANDLE32, lpNXPResetReadProtectParams: LPNXP_RESET_READ_PROTECT_PARAMS, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_PerformNXPEASScan(readerHandle: RFID_HANDLE32, lpAntennaInfo: LPANTENNA_INFO, lpTriggerInfo: LPTRIGGER_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_StopNXPEASScan(readerHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_FujitsuChangeWordLock(rfidHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpChangeWordLockParams: LPFUJITSU_CHANGE_WORDLOCK_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_FujitsuChangeBlockLock(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpChangeBlockLockParams: LPFUJITSU_CHANGE_BLOCKLOCK_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_FujitsuReadBlockLock(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpReadBlockLockParams: LPFUJITSU_READ_BLOCKLOCK_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTagData: LPTAG_DATA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_FujitsuBurstWrite(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpBurstWriteParams: LPFUJITSU_BURST_WRITE_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTagData: LPTAG_DATA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_FujitsuBurstErase(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpBurstEraseParams: LPFUJITSU_BURST_ERASE_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTagData: LPTAG_DATA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_FujitsuChangeBlockOrAreaGroupPassword(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpChangeBlockOrAreaGroupPasswordParams: LPFUJITSU_CHANGE_BLOCK_OR_AREA_GROUPPASSWORD_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_FujitsuAreaReadLock(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpAreaReadLockParams: LPFUJITSU_AREA_READLOCK_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_FujitsuAreaWriteLock(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpAreaWriteLockParams: LPFUJITSU_AREA_WRITELOCK_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_FujitsuAreaWriteLockWOPassword(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpAreaWriteLockWOPasswordParams: LPFUJITSU_AREA_WRITELOCK_WOPASSWORD_ACCESS_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_ImpinjQTWrite(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpQTWriteParams: LPIMPINJ_QT_WRITE_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_ImpinjQTRead(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpQTReadParams: LPIMPINJ_QT_READ_PARMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTagData: LPTAG_DATA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_NXPChangeConfig(readerHandle: RFID_HANDLE32, pTagID: [*c]UINT8, tagIDLength: UINT32, lpNXPChangeConfigParams: LPNXP_CHANGE_CONFIG_PARAMS, lpAccessFilter: LPACCESS_FILTER, lpAntennaInfo: LPANTENNA_INFO, lpTagData: LPTAG_DATA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_LoginW(pReaderManagementHandle: [*c]RFID_HANDLE32, lpLoginInfo: LPLOGIN_INFOW, readerType: READER_TYPE, secureMode: BOOLEAN, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_LoginA(pReaderManagementHandle: [*c]RFID_HANDLE32, lpLoginInfo: LPLOGIN_INFOA, readerType: READER_TYPE, secureMode: BOOLEAN, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_Logout(readerManagementHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_EnableReadPoint(readerManagementHandle: RFID_HANDLE32, antennaID: UINT16, status: BOOLEAN) RFID_STATUS;
pub extern fn RFID_GetReadPointStatus(readerManagementHandle: RFID_HANDLE32, antennaID: UINT16, pStatus: [*c]BOOLEAN) RFID_STATUS;
pub extern fn RFID_GetReadPointConnectStatus(readerManagementHandle: RFID_HANDLE32, antennaID: UINT16, pConnectStatus: [*c]BOOLEAN) RFID_STATUS;
pub extern fn RFID_SetAntennaMode(readerManagementHandle: RFID_HANDLE32, antennaMode: ANTENNA_MODE) RFID_STATUS;
pub extern fn RFID_GetAntennaMode(readerManagementHandle: RFID_HANDLE32, pAntennaMode: [*c]ANTENNA_MODE) RFID_STATUS;
pub extern fn RFID_ExportProfileToReaderW(readerManagementHandle: RFID_HANDLE32, pProfileName: [*c]WCHAR, pProfilePath: [*c]WCHAR, activation: BOOLEAN) RFID_STATUS;
pub extern fn RFID_ExportProfileToReaderA(readerManagementHandle: RFID_HANDLE32, pProfileName: [*c]CHAR, pProfilePath: [*c]CHAR, activation: BOOLEAN) RFID_STATUS;
pub extern fn RFID_TurnOffRadioWhenIdle(readerManagementHandle: RFID_HANDLE32, idleTimeoutSeconds: INT32) RFID_STATUS;
pub extern fn RFID_GetRadioIdleTimeout(readerManagementHandle: RFID_HANDLE32, pIdleTimeoutSeconds: [*c]INT32) RFID_STATUS;
pub extern fn RFID_InstallUserAppW(readerManagementHandle: RFID_HANDLE32, pPathToPackage: [*c]WCHAR) RFID_STATUS;
pub extern fn RFID_InstallUserAppA(readerManagementHandle: RFID_HANDLE32, pPathToPackage: [*c]CHAR) RFID_STATUS;
pub extern fn RFID_UninstallUserAppW(readerManagementHandle: RFID_HANDLE32, pAppName: [*c]WCHAR) RFID_STATUS;
pub extern fn RFID_UninstallUserAppA(readerManagementHandle: RFID_HANDLE32, pAppName: [*c]CHAR) RFID_STATUS;
pub extern fn RFID_StartUserAppW(readerManagementHandle: RFID_HANDLE32, pAppName: [*c]WCHAR) RFID_STATUS;
pub extern fn RFID_StartUserAppA(readerManagementHandle: RFID_HANDLE32, pAppName: [*c]CHAR) RFID_STATUS;
pub extern fn RFID_StopUserAppW(readerManagementHandle: RFID_HANDLE32, pAppName: [*c]WCHAR) RFID_STATUS;
pub extern fn RFID_StopUserAppA(readerHandle: RFID_HANDLE32, pAppName: [*c]CHAR) RFID_STATUS;
pub extern fn RFID_GetUserAppRunStatusW(readerManagementHandle: RFID_HANDLE32, pAppName: [*c]WCHAR, pRunStatus: [*c]BOOLEAN) RFID_STATUS;
pub extern fn RFID_GetUserAppRunStatusA(readerManagementHandle: RFID_HANDLE32, pAppName: [*c]CHAR, pRunStatus: [*c]BOOLEAN) RFID_STATUS;
pub extern fn RFID_ListUserAppsW(readerManagementHandle: RFID_HANDLE32, lpAppList: LPUSERAPP_LISTW) RFID_STATUS;
pub extern fn RFID_ListUserAppsA(readerManagementHandle: RFID_HANDLE32, lpAppList: LPUSERAPP_LISTA) RFID_STATUS;
pub extern fn RFID_SetUserAppAutoStartW(readerManagementHandle: RFID_HANDLE32, pAppName: [*c]WCHAR, Enable: BOOLEAN) RFID_STATUS;
pub extern fn RFID_SetUserAppAutoStartA(readerManagementHandle: RFID_HANDLE32, pAppName: [*c]CHAR, Enable: BOOLEAN) RFID_STATUS;
pub extern fn RFID_ImportProfileFromReaderW(readerManagementHandle: RFID_HANDLE32, pProfileName: [*c]WCHAR, pProfilePath: [*c]WCHAR) RFID_STATUS;
pub extern fn RFID_ImportProfileFromReaderA(readerManagementHandle: RFID_HANDLE32, pProfileName: [*c]CHAR, pProfilePath: [*c]CHAR) RFID_STATUS;
pub extern fn RFID_GetProfileListW(readerManagementHandle: RFID_HANDLE32, lpProfileList: LPPROFILE_LISTW) RFID_STATUS;
pub extern fn RFID_GetProfileListA(readerManagementHandle: RFID_HANDLE32, lpProfileList: LPPROFILE_LISTA) RFID_STATUS;
pub extern fn RFID_SetActiveProfileW(readerManagementHandle: RFID_HANDLE32, pProfileName: [*c]WCHAR) RFID_STATUS;
pub extern fn RFID_SetActiveProfileA(readerManagementHandle: RFID_HANDLE32, pProfileName: [*c]CHAR) RFID_STATUS;
pub extern fn RFID_DeleteProfileW(readerManagementHandle: RFID_HANDLE32, pProfileName: [*c]WCHAR) RFID_STATUS;
pub extern fn RFID_DeleteProfileA(readerManagementHandle: RFID_HANDLE32, pProfileName: [*c]CHAR) RFID_STATUS;
pub extern fn RFID_UpdateSoftwareW(readerManagementHandle: RFID_HANDLE32, pLocationInfo: LPFTPSERVER_INFOW) RFID_STATUS;
pub extern fn RFID_UpdateSoftwareA(readerManagementHandle: RFID_HANDLE32, pLocationInfo: LPFTPSERVER_INFOA) RFID_STATUS;
pub extern fn RFID_UpdateRadioFirmwareW(readerManagementHandle: RFID_HANDLE32, pFileName: [*c]WCHAR) RFID_STATUS;
pub extern fn RFID_UpdateRadioFirmwareA(readerManagementHandle: RFID_HANDLE32, pFileName: [*c]CHAR) RFID_STATUS;
pub extern fn RFID_AcquireLicenseOnLineW(readerManagementHandle: RFID_HANDLE32, pLicenseServerURL: [*c]WCHAR, pActivationID: [*c]WCHAR, installApp: BOOLEAN, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_AcquireLicenseOnLineA(readerManagementHandle: RFID_HANDLE32, pLicenseServerURL: [*c]CHAR, pActivationID: [*c]CHAR, installApp: BOOLEAN, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_AcquireLicenseOffLineW(readerManagementHandle: RFID_HANDLE32, pLicenseBinFileLocation: [*c]WCHAR, installApp: BOOLEAN, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_AcquireLicenseOffLineA(readerManagementHandle: RFID_HANDLE32, pLicenseBinFileLocation: [*c]CHAR, installApp: BOOLEAN, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_ReturnLicenseW(readerManagementHandle: RFID_HANDLE32, pLicenseServerURL: [*c]WCHAR, pActivationID: [*c]WCHAR, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_ReturnLicenseA(readerManagementHandle: RFID_HANDLE32, pLicenseServerURL: [*c]CHAR, pActivationID: [*c]CHAR, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_GetAvailableLicensesW(readerManagementHandle: RFID_HANDLE32, lpLicenseList: LPLICENSE_LISTW, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_GetAvailableLicensesA(readerManagementHandle: RFID_HANDLE32, lpLicenseList: LPLICENSE_LISTA, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_UpdateRadioConfigW(readerManagementHandle: RFID_HANDLE32, pFileName: [*c]WCHAR) RFID_STATUS;
pub extern fn RFID_UpdateRadioConfigA(readerManagementHandle: RFID_HANDLE32, pFileName: [*c]CHAR) RFID_STATUS;
pub extern fn RFID_GetUpdateStatusW(readerManagementHandle: RFID_HANDLE32, lpStatus: LPUPDATE_STATUSW) RFID_STATUS;
pub extern fn RFID_GetUpdateStatusA(readerManagementHandle: RFID_HANDLE32, lpStatus: LPUPDATE_STATUSA) RFID_STATUS;
pub extern fn RFID_Restart(readerManagementHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_GetSystemInfoW(readerManagementHandle: RFID_HANDLE32, lpSystemInfo: LPREADER_SYSTEM_INFOW) RFID_STATUS;
pub extern fn RFID_GetSystemInfoA(readerManagementHandle: RFID_HANDLE32, lpSystemInfo: LPREADER_SYSTEM_INFOA) RFID_STATUS;
pub extern fn RFID_GetNetworkInterfaceSettingsW(readerManagementHandle: RFID_HANDLE32, lpnetworkInfo: LPREADER_NETWORK_INFOW) RFID_STATUS;
pub extern fn RFID_GetNetworkInterfaceSettingsA(readerManagementHandle: RFID_HANDLE32, lpnetworkInfo: LPREADER_NETWORK_INFOA) RFID_STATUS;
pub extern fn RFID_SetNetworkInterfaceSettingsW(readerManagementHandle: RFID_HANDLE32, lpnetworkInfo: LPREADER_NETWORK_INFOW) RFID_STATUS;
pub extern fn RFID_SetNetworkInterfaceSettingsA(readerManagementHandle: RFID_HANDLE32, lpnetworkInfo: LPREADER_NETWORK_INFOA) RFID_STATUS;
pub extern fn RFID_GetHealthStatus(readerManagementHandle: RFID_HANDLE32, serviceID: SERVICE_ID, pHealthStatus: [*c]HEALTH_STATUS, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_GetUSBOperationMode(readerManagementHandle: RFID_HANDLE32, lpUsbOperationInfo: LPUSB_OPERATION_INFO) RFID_STATUS;
pub extern fn RFID_SetUSBOperationMode(readerManagementHandle: RFID_HANDLE32, lpUsbOperationInfo: LPUSB_OPERATION_INFO) RFID_STATUS;
pub extern fn RFID_GetGPIDebounceTime(readerManagementHandle: RFID_HANDLE32, pDebounceTimeMilliseconds: [*c]UINT32, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_SetGPIDebounceTime(readerManagementHandle: RFID_HANDLE32, debounceTimeMilliseconds: UINT32, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_SetUserLED(readerManagementHandle: RFID_HANDLE32, lpLedInfo: LPLED_INFO) RFID_STATUS;
pub extern fn RFID_GetLocalTime(readerManagementHandle: RFID_HANDLE32, lpSystemTime: LPSYSTEMTIME) RFID_STATUS;
pub extern fn RFID_SetLocalTime(readerManagementHandle: RFID_HANDLE32, lpSystemTime: LPSYSTEMTIME) RFID_STATUS;
pub extern fn RFID_GetReaderStats(readerManagementHandle: RFID_HANDLE32, antennaID: UINT16, lpReaderStats: LPREADER_STATS) RFID_STATUS;
pub extern fn RFID_ClearReaderStats(readerManagementHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_SetReaderInfoW(readerManagementHandle: RFID_HANDLE32, lpReaderInfo: LPREADER_INFOW) RFID_STATUS;
pub extern fn RFID_SetReaderInfoA(readerManagementHandle: RFID_HANDLE32, lpReaderInfo: LPREADER_INFOA) RFID_STATUS;
pub extern fn RFID_GetReaderInfoW(readerManagementHandle: RFID_HANDLE32, lpReaderInfo: LPREADER_INFOW) RFID_STATUS;
pub extern fn RFID_GetReaderInfoA(readerManagementHandle: RFID_HANDLE32, lpReaderInfo: LPREADER_INFOA) RFID_STATUS;
pub extern fn RFID_GetTimeZoneListW(readerManagementHandle: RFID_HANDLE32, lpTimeZoneList: LPTIME_ZONE_LISTW) RFID_STATUS;
pub extern fn RFID_GetTimeZoneListA(readerManagementHandle: RFID_HANDLE32, lpTimeZoneList: LPTIME_ZONE_LISTA) RFID_STATUS;
pub extern fn RFID_SetTimeZone(readerManagementHandle: RFID_HANDLE32, timeZoneIndex: UINT16) RFID_STATUS;
pub extern fn RFID_GetLLRPConnectionConfigW(readerManagementHandle: RFID_HANDLE32, lpLLRPConnectionConfig: LPLLRP_CONNECTION_CONFIGW) RFID_STATUS;
pub extern fn RFID_GetLLRPConnectionConfigA(readerManagementHandle: RFID_HANDLE32, lpLLRPConnectionConfig: LPLLRP_CONNECTION_CONFIGA) RFID_STATUS;
pub extern fn RFID_SetLLRPConnectionConfigW(readerManagementHandle: RFID_HANDLE32, lpLLRPConnectionConfig: LPLLRP_CONNECTION_CONFIGW) RFID_STATUS;
pub extern fn RFID_SetLLRPConnectionConfigA(readerManagementHandle: RFID_HANDLE32, lpLLRPConnectionConfig: LPLLRP_CONNECTION_CONFIGA) RFID_STATUS;
pub extern fn RFID_GetLLRPConnectionStatusW(readerManagementHandle: RFID_HANDLE32, lpLLRPConnectionStatus: LPLLRP_CONNECTION_STATUSW) RFID_STATUS;
pub extern fn RFID_GetLLRPConnectionStatusA(readerManagementHandle: RFID_HANDLE32, lpLLRPConnectionStatus: LPLLRP_CONNECTION_STATUSA) RFID_STATUS;
pub extern fn RFID_InitiateLLRPConnectionFromReader(readerManagementHandle: RFID_HANDLE32, rsvd: LPVOID) RFID_STATUS;
pub extern fn RFID_DisconnectLLRPConnectionFromReader(readerManagementHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_SetTraceLevel(readerHandle: RFID_HANDLE32, traceLevel: UINT32) RFID_STATUS;
pub extern fn RFID_GetErrorDescriptionW(errorCode: RFID_STATUS) [*c]WCHAR;
pub extern fn RFID_GetErrorDescriptionA(errorCode: RFID_STATUS) [*c]CHAR;
pub extern fn RFID_GetLastErrorInfoW(readerHandle: RFID_HANDLE32, lpErrorInfo: LPERROR_INFOW) RFID_STATUS;
pub extern fn RFID_GetLastErrorInfoA(readerHandle: RFID_HANDLE32, lpErrorInfo: LPERROR_INFOA) RFID_STATUS;
pub extern fn RFID_SetCableLossCompensation(readerManagementHandle: RFID_HANDLE32, nTotalAntennasToSet: UINT16, lppCableLossCompensation: [*c]LPCABLE_LOSS_COMPENSATION) RFID_STATUS;
pub extern fn RFID_GetCableLossCompensation(readerManagementHandle: RFID_HANDLE32, lpCableLossCompensation: LPCABLE_LOSS_COMPENSATION) RFID_STATUS;
pub extern fn RFID_GetSupportedRegionListW(readerManagementHandle: RFID_HANDLE32, SupportedRegions: [*c]REGION_LISTW) RFID_STATUS;
pub extern fn RFID_GetSupportedRegionListA(readerManagementHandle: RFID_HANDLE32, SupportedRegions: [*c]REGION_LISTA) RFID_STATUS;
pub extern fn RFID_GetRegionStandardListW(readerManagementHandle: RFID_HANDLE32, RegionName: [*c]WCHAR, RegionStds: [*c]STANDARD_INFO_LISTW) RFID_STATUS;
pub extern fn RFID_GetRegionStandardListA(readerManagementHandle: RFID_HANDLE32, RegionName: [*c]CHAR, RegionStds: [*c]STANDARD_INFO_LISTA) RFID_STATUS;
pub extern fn RFID_SetActiveRegionW(readerManagementHandle: RFID_HANDLE32, RegionName: [*c]WCHAR, CommunicationStandardName: [*c]WCHAR) RFID_STATUS;
pub extern fn RFID_SetActiveRegionA(readerManagementHandle: RFID_HANDLE32, RegionName: [*c]CHAR, CommunicationStandardName: [*c]CHAR) RFID_STATUS;
pub extern fn RFID_SetFrequencySetting(readerManagementHandle: RFID_HANDLE32, bEnableFrequencyHopping: BOOLEAN, lpChannelTable: [*c]CHANNEL_LIST) RFID_STATUS;
pub extern fn RFID_GetActiveRegionInfoW(readerManagementHandle: RFID_HANDLE32, ActiveRegionInfo: [*c]ACTIVE_REGION_INFOW) RFID_STATUS;
pub extern fn RFID_GetActiveRegionInfoA(readerManagementHandle: RFID_HANDLE32, ActiveRegionInfo: [*c]ACTIVE_REGION_INFOA) RFID_STATUS;
pub extern fn RFID_GetActiveRegionStandardInfoW(readerManagementHandle: RFID_HANDLE32, CurrentActiveRegionStandardInfo: [*c]STANDARD_REGION_INFOW) RFID_STATUS;
pub extern fn RFID_GetActiveRegionStandardInfoA(readerManagementHandle: RFID_HANDLE32, CurrentActiveRegionStandardInfo: [*c]STANDARD_REGION_INFOA) RFID_STATUS;
pub extern fn RFID_ChangePasswordW(readerManagementHandle: RFID_HANDLE32, lpUserInfo: [*c]USER_INFOW) RFID_STATUS;
pub extern fn RFID_ChangePasswordA(readerManagementHandle: RFID_HANDLE32, lpUserInfo: [*c]USER_INFOA) RFID_STATUS;
pub extern fn RFID_GetPowerNegotiationState(readerManagementHandle: RFID_HANDLE32, lpPowerNegotiationInfo: [*c]BOOLEAN) RFID_STATUS;
pub extern fn RFID_SetPowerNegotiationState(readerManagementHandle: RFID_HANDLE32, powerNegotiationInfo: BOOLEAN) RFID_STATUS;
pub extern fn RFID_GetPowerNegotiationStatus(readerManagementHandle: RFID_HANDLE32, lpPowerNegotiationStatus: [*c]POWER_NEGOTIATION_STATUS) RFID_STATUS;
pub extern fn RFID_FactoryReset(readerManagementHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_EnterpriseReset(readerManagementHandle: RFID_HANDLE32) RFID_STATUS;
pub extern fn RFID_SetNTPServerW(readerManagementHandle: RFID_HANDLE32, lpTimeServerInfo: LPTIME_SERVER_INFOW) RFID_STATUS;
pub extern fn RFID_SetNTPServerA(readerManagementHandle: RFID_HANDLE32, lpTimeServerInfo: LPTIME_SERVER_INFOA) RFID_STATUS;
pub extern fn RFID_GetNTPServerW(readerManagementHandle: RFID_HANDLE32, lpTimeServerInfo: LPTIME_SERVER_INFOW) RFID_STATUS;
pub extern fn RFID_GetNTPServerA(readerManagementHandle: RFID_HANDLE32, lpTimeServerInfo: LPTIME_SERVER_INFOA) RFID_STATUS;
pub extern fn RFID_SetWirelessNetworkW(readerManagementHandle: RFID_HANDLE32, lpWirelessConfiguredParameters: LPWIRELESS_CONFIGURED_PARAMETERSW) RFID_STATUS;
pub extern fn RFID_SetWirelessNetworkA(readerManagementHandle: RFID_HANDLE32, lpWirelessConfiguredParameters: LPWIRELESS_CONFIGURED_PARAMETERSA) RFID_STATUS;
pub extern fn RFID_SetSysLogServerW(readerManagementHandle: RFID_HANDLE32, lpSysLogServerInfo: LPSYSLOG_SERVER_INFOW) RFID_STATUS;
pub extern fn RFID_SetSysLogServerA(readerManagementHandle: RFID_HANDLE32, lpSysLogServerInfo: LPSYSLOG_SERVER_INFOA) RFID_STATUS;
pub extern fn RFID_GetSysLogServerW(readerManagementHandle: RFID_HANDLE32, lpSysLogServerInfo: LPSYSLOG_SERVER_INFOW) RFID_STATUS;
pub extern fn RFID_GetSysLogServerA(readerManagementHandle: RFID_HANDLE32, lpSysLogServerInfo: LPSYSLOG_SERVER_INFOA) RFID_STATUS;
pub extern fn RFID_GetWirelessConfigParametersW(readerManagementHandle: RFID_HANDLE32, lpWirelessConfiguredParameters: LPWIRELESS_CONFIGURED_PARAMETERSW) RFID_STATUS;
pub extern fn RFID_GetWirelessConfigParametersA(readerManagementHandle: RFID_HANDLE32, lpWirelessConfiguredParameters: LPWIRELESS_CONFIGURED_PARAMETERSA) RFID_STATUS;
pub extern fn RFID_GetTemperatureStatusW(readerManagementHandle: RFID_HANDLE32, lpTemperatureStatus: LPTEMPERATURE_STATUSW) RFID_STATUS;
pub extern fn RFID_GetTemperatureStatusA(readerManagementHandle: RFID_HANDLE32, lpTemperatureStatus: LPTEMPERATURE_STATUSA) RFID_STATUS;
pub extern fn RFID_GetRadioTransmitDelay(readerHandle: RFID_HANDLE32, pType: [*c]RADIO_TRANSMIT_DELAY_TYPE, pTime: [*c]UINT8) RFID_STATUS;
pub extern fn RFID_SetRadioTransmitDelay(readerHandle: RFID_HANDLE32, @"type": RADIO_TRANSMIT_DELAY_TYPE, time: UINT8) RFID_STATUS;
pub extern fn RFID_GetMLTAlgorithmParameters(readerHandle: RFID_HANDLE32, pMLTConfiguration: [*c]MLT_ALGORITHM_PARAMS) RFID_STATUS;
pub extern fn RFID_SetMLTAlgorithmParameters(readerHandle: RFID_HANDLE32, MLTConfiguration: MLT_ALGORITHM_PARAMS) RFID_STATUS;
pub extern fn RFID_GetFilesToUpdateW(readerManagementHandle: RFID_HANDLE32, lpUpdateFileList: LPFILE_UPDATE_LISTW) RFID_STATUS;
pub extern fn RFID_GetFilesToUpdateA(readerManagementHandle: RFID_HANDLE32, lpUpdateFileList: LPFILE_UPDATE_LISTA) RFID_STATUS;
pub extern fn RFID_UpdatePartition(readerManagementHandle: RFID_HANDLE32, partitionIndex: UINT16) RFID_STATUS;
pub extern fn RFID_GetUpdatePartitionStatusW(readerManagementHandle: RFID_HANDLE32, lpStatus: LPUPDATE_PARTITION_STATUSW) RFID_STATUS;
pub extern fn RFID_GetUpdatePartitionStatusA(readerManagementHandle: RFID_HANDLE32, lpStatus: LPUPDATE_PARTITION_STATUSA) RFID_STATUS;
pub extern fn RFID_UpdateComplete(readerManagementHandle: RFID_HANDLE32) RFID_STATUS;
pub const __llvm__ = @as(c_int, 1);
pub const __clang__ = @as(c_int, 1);
pub const __clang_major__ = @as(c_int, 20);
pub const __clang_minor__ = @as(c_int, 1);
pub const __clang_patchlevel__ = @as(c_int, 2);
pub const __clang_version__ = "20.1.2 (https://github.com/ziglang/zig-bootstrap 7ef74e656cf8ddbd6bf891a8475892aa1afa6891)";
pub const __GNUC__ = @as(c_int, 4);
pub const __GNUC_MINOR__ = @as(c_int, 2);
pub const __GNUC_PATCHLEVEL__ = @as(c_int, 1);
pub const __GXX_ABI_VERSION = @as(c_int, 1002);
pub const __ATOMIC_RELAXED = @as(c_int, 0);
pub const __ATOMIC_CONSUME = @as(c_int, 1);
pub const __ATOMIC_ACQUIRE = @as(c_int, 2);
pub const __ATOMIC_RELEASE = @as(c_int, 3);
pub const __ATOMIC_ACQ_REL = @as(c_int, 4);
pub const __ATOMIC_SEQ_CST = @as(c_int, 5);
pub const __MEMORY_SCOPE_SYSTEM = @as(c_int, 0);
pub const __MEMORY_SCOPE_DEVICE = @as(c_int, 1);
pub const __MEMORY_SCOPE_WRKGRP = @as(c_int, 2);
pub const __MEMORY_SCOPE_WVFRNT = @as(c_int, 3);
pub const __MEMORY_SCOPE_SINGLE = @as(c_int, 4);
pub const __OPENCL_MEMORY_SCOPE_WORK_ITEM = @as(c_int, 0);
pub const __OPENCL_MEMORY_SCOPE_WORK_GROUP = @as(c_int, 1);
pub const __OPENCL_MEMORY_SCOPE_DEVICE = @as(c_int, 2);
pub const __OPENCL_MEMORY_SCOPE_ALL_SVM_DEVICES = @as(c_int, 3);
pub const __OPENCL_MEMORY_SCOPE_SUB_GROUP = @as(c_int, 4);
pub const __FPCLASS_SNAN = @as(c_int, 0x0001);
pub const __FPCLASS_QNAN = @as(c_int, 0x0002);
pub const __FPCLASS_NEGINF = @as(c_int, 0x0004);
pub const __FPCLASS_NEGNORMAL = @as(c_int, 0x0008);
pub const __FPCLASS_NEGSUBNORMAL = @as(c_int, 0x0010);
pub const __FPCLASS_NEGZERO = @as(c_int, 0x0020);
pub const __FPCLASS_POSZERO = @as(c_int, 0x0040);
pub const __FPCLASS_POSSUBNORMAL = @as(c_int, 0x0080);
pub const __FPCLASS_POSNORMAL = @as(c_int, 0x0100);
pub const __FPCLASS_POSINF = @as(c_int, 0x0200);
pub const __PRAGMA_REDEFINE_EXTNAME = @as(c_int, 1);
pub const __VERSION__ = "Clang 20.1.2 (https://github.com/ziglang/zig-bootstrap 7ef74e656cf8ddbd6bf891a8475892aa1afa6891)";
pub const __OBJC_BOOL_IS_BOOL = @as(c_int, 0);
pub const __CONSTANT_CFSTRINGS__ = @as(c_int, 1);
pub const __clang_literal_encoding__ = "UTF-8";
pub const __clang_wide_literal_encoding__ = "UTF-32";
pub const __ORDER_LITTLE_ENDIAN__ = @as(c_int, 1234);
pub const __ORDER_BIG_ENDIAN__ = @as(c_int, 4321);
pub const __ORDER_PDP_ENDIAN__ = @as(c_int, 3412);
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __LITTLE_ENDIAN__ = @as(c_int, 1);
pub const _LP64 = @as(c_int, 1);
pub const __LP64__ = @as(c_int, 1);
pub const __CHAR_BIT__ = @as(c_int, 8);
pub const __BOOL_WIDTH__ = @as(c_int, 1);
pub const __SHRT_WIDTH__ = @as(c_int, 16);
pub const __INT_WIDTH__ = @as(c_int, 32);
pub const __LONG_WIDTH__ = @as(c_int, 64);
pub const __LLONG_WIDTH__ = @as(c_int, 64);
pub const __BITINT_MAXWIDTH__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 8388608, .decimal);
pub const __SCHAR_MAX__ = @as(c_int, 127);
pub const __SHRT_MAX__ = @as(c_int, 32767);
pub const __INT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __LONG_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __LONG_LONG_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __WCHAR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __WCHAR_WIDTH__ = @as(c_int, 32);
pub const __WINT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __WINT_WIDTH__ = @as(c_int, 32);
pub const __INTMAX_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTMAX_WIDTH__ = @as(c_int, 64);
pub const __SIZE_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __SIZE_WIDTH__ = @as(c_int, 64);
pub const __UINTMAX_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTMAX_WIDTH__ = @as(c_int, 64);
pub const __PTRDIFF_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __PTRDIFF_WIDTH__ = @as(c_int, 64);
pub const __INTPTR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTPTR_WIDTH__ = @as(c_int, 64);
pub const __UINTPTR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTPTR_WIDTH__ = @as(c_int, 64);
pub const __SIZEOF_DOUBLE__ = @as(c_int, 8);
pub const __SIZEOF_FLOAT__ = @as(c_int, 4);
pub const __SIZEOF_INT__ = @as(c_int, 4);
pub const __SIZEOF_LONG__ = @as(c_int, 8);
pub const __SIZEOF_LONG_DOUBLE__ = @as(c_int, 16);
pub const __SIZEOF_LONG_LONG__ = @as(c_int, 8);
pub const __SIZEOF_POINTER__ = @as(c_int, 8);
pub const __SIZEOF_SHORT__ = @as(c_int, 2);
pub const __SIZEOF_PTRDIFF_T__ = @as(c_int, 8);
pub const __SIZEOF_SIZE_T__ = @as(c_int, 8);
pub const __SIZEOF_WCHAR_T__ = @as(c_int, 4);
pub const __SIZEOF_WINT_T__ = @as(c_int, 4);
pub const __SIZEOF_INT128__ = @as(c_int, 16);
pub const __INTMAX_TYPE__ = c_long;
pub const __INTMAX_FMTd__ = "ld";
pub const __INTMAX_FMTi__ = "li";
pub const __INTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`");
// (no file):95:9
pub const __INTMAX_C = @import("std").zig.c_translation.Macros.L_SUFFIX;
pub const __UINTMAX_TYPE__ = c_ulong;
pub const __UINTMAX_FMTo__ = "lo";
pub const __UINTMAX_FMTu__ = "lu";
pub const __UINTMAX_FMTx__ = "lx";
pub const __UINTMAX_FMTX__ = "lX";
pub const __UINTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`");
// (no file):102:9
pub const __UINTMAX_C = @import("std").zig.c_translation.Macros.UL_SUFFIX;
pub const __PTRDIFF_TYPE__ = c_long;
pub const __PTRDIFF_FMTd__ = "ld";
pub const __PTRDIFF_FMTi__ = "li";
pub const __INTPTR_TYPE__ = c_long;
pub const __INTPTR_FMTd__ = "ld";
pub const __INTPTR_FMTi__ = "li";
pub const __SIZE_TYPE__ = c_ulong;
pub const __SIZE_FMTo__ = "lo";
pub const __SIZE_FMTu__ = "lu";
pub const __SIZE_FMTx__ = "lx";
pub const __SIZE_FMTX__ = "lX";
pub const __WCHAR_TYPE__ = c_int;
pub const __WINT_TYPE__ = c_uint;
pub const __SIG_ATOMIC_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __SIG_ATOMIC_WIDTH__ = @as(c_int, 32);
pub const __CHAR16_TYPE__ = c_ushort;
pub const __CHAR32_TYPE__ = c_uint;
pub const __UINTPTR_TYPE__ = c_ulong;
pub const __UINTPTR_FMTo__ = "lo";
pub const __UINTPTR_FMTu__ = "lu";
pub const __UINTPTR_FMTx__ = "lx";
pub const __UINTPTR_FMTX__ = "lX";
pub const __FLT16_DENORM_MIN__ = @as(f16, 5.9604644775390625e-8);
pub const __FLT16_NORM_MAX__ = @as(f16, 6.5504e+4);
pub const __FLT16_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT16_DIG__ = @as(c_int, 3);
pub const __FLT16_DECIMAL_DIG__ = @as(c_int, 5);
pub const __FLT16_EPSILON__ = @as(f16, 9.765625e-4);
pub const __FLT16_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT16_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT16_MANT_DIG__ = @as(c_int, 11);
pub const __FLT16_MAX_10_EXP__ = @as(c_int, 4);
pub const __FLT16_MAX_EXP__ = @as(c_int, 16);
pub const __FLT16_MAX__ = @as(f16, 6.5504e+4);
pub const __FLT16_MIN_10_EXP__ = -@as(c_int, 4);
pub const __FLT16_MIN_EXP__ = -@as(c_int, 13);
pub const __FLT16_MIN__ = @as(f16, 6.103515625e-5);
pub const __FLT_DENORM_MIN__ = @as(f32, 1.40129846e-45);
pub const __FLT_NORM_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT_DIG__ = @as(c_int, 6);
pub const __FLT_DECIMAL_DIG__ = @as(c_int, 9);
pub const __FLT_EPSILON__ = @as(f32, 1.19209290e-7);
pub const __FLT_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT_MANT_DIG__ = @as(c_int, 24);
pub const __FLT_MAX_10_EXP__ = @as(c_int, 38);
pub const __FLT_MAX_EXP__ = @as(c_int, 128);
pub const __FLT_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_MIN_10_EXP__ = -@as(c_int, 37);
pub const __FLT_MIN_EXP__ = -@as(c_int, 125);
pub const __FLT_MIN__ = @as(f32, 1.17549435e-38);
pub const __DBL_DENORM_MIN__ = @as(f64, 4.9406564584124654e-324);
pub const __DBL_NORM_MAX__ = @as(f64, 1.7976931348623157e+308);
pub const __DBL_HAS_DENORM__ = @as(c_int, 1);
pub const __DBL_DIG__ = @as(c_int, 15);
pub const __DBL_DECIMAL_DIG__ = @as(c_int, 17);
pub const __DBL_EPSILON__ = @as(f64, 2.2204460492503131e-16);
pub const __DBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __DBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __DBL_MANT_DIG__ = @as(c_int, 53);
pub const __DBL_MAX_10_EXP__ = @as(c_int, 308);
pub const __DBL_MAX_EXP__ = @as(c_int, 1024);
pub const __DBL_MAX__ = @as(f64, 1.7976931348623157e+308);
pub const __DBL_MIN_10_EXP__ = -@as(c_int, 307);
pub const __DBL_MIN_EXP__ = -@as(c_int, 1021);
pub const __DBL_MIN__ = @as(f64, 2.2250738585072014e-308);
pub const __LDBL_DENORM_MIN__ = @as(c_longdouble, 3.64519953188247460253e-4951);
pub const __LDBL_NORM_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_HAS_DENORM__ = @as(c_int, 1);
pub const __LDBL_DIG__ = @as(c_int, 18);
pub const __LDBL_DECIMAL_DIG__ = @as(c_int, 21);
pub const __LDBL_EPSILON__ = @as(c_longdouble, 1.08420217248550443401e-19);
pub const __LDBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __LDBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __LDBL_MANT_DIG__ = @as(c_int, 64);
pub const __LDBL_MAX_10_EXP__ = @as(c_int, 4932);
pub const __LDBL_MAX_EXP__ = @as(c_int, 16384);
pub const __LDBL_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_MIN_10_EXP__ = -@as(c_int, 4931);
pub const __LDBL_MIN_EXP__ = -@as(c_int, 16381);
pub const __LDBL_MIN__ = @as(c_longdouble, 3.36210314311209350626e-4932);
pub const __POINTER_WIDTH__ = @as(c_int, 64);
pub const __BIGGEST_ALIGNMENT__ = @as(c_int, 16);
pub const __WINT_UNSIGNED__ = @as(c_int, 1);
pub const __INT8_TYPE__ = i8;
pub const __INT8_FMTd__ = "hhd";
pub const __INT8_FMTi__ = "hhi";
pub const __INT8_C_SUFFIX__ = "";
pub inline fn __INT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __INT16_TYPE__ = c_short;
pub const __INT16_FMTd__ = "hd";
pub const __INT16_FMTi__ = "hi";
pub const __INT16_C_SUFFIX__ = "";
pub inline fn __INT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __INT32_TYPE__ = c_int;
pub const __INT32_FMTd__ = "d";
pub const __INT32_FMTi__ = "i";
pub const __INT32_C_SUFFIX__ = "";
pub inline fn __INT32_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __INT64_TYPE__ = c_long;
pub const __INT64_FMTd__ = "ld";
pub const __INT64_FMTi__ = "li";
pub const __INT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`");
// (no file):207:9
pub const __INT64_C = @import("std").zig.c_translation.Macros.L_SUFFIX;
pub const __UINT8_TYPE__ = u8;
pub const __UINT8_FMTo__ = "hho";
pub const __UINT8_FMTu__ = "hhu";
pub const __UINT8_FMTx__ = "hhx";
pub const __UINT8_FMTX__ = "hhX";
pub const __UINT8_C_SUFFIX__ = "";
pub inline fn __UINT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __UINT8_MAX__ = @as(c_int, 255);
pub const __INT8_MAX__ = @as(c_int, 127);
pub const __UINT16_TYPE__ = c_ushort;
pub const __UINT16_FMTo__ = "ho";
pub const __UINT16_FMTu__ = "hu";
pub const __UINT16_FMTx__ = "hx";
pub const __UINT16_FMTX__ = "hX";
pub const __UINT16_C_SUFFIX__ = "";
pub inline fn __UINT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __UINT16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __INT16_MAX__ = @as(c_int, 32767);
pub const __UINT32_TYPE__ = c_uint;
pub const __UINT32_FMTo__ = "o";
pub const __UINT32_FMTu__ = "u";
pub const __UINT32_FMTx__ = "x";
pub const __UINT32_FMTX__ = "X";
pub const __UINT32_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `U`");
// (no file):232:9
pub const __UINT32_C = @import("std").zig.c_translation.Macros.U_SUFFIX;
pub const __UINT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __UINT64_TYPE__ = c_ulong;
pub const __UINT64_FMTo__ = "lo";
pub const __UINT64_FMTu__ = "lu";
pub const __UINT64_FMTx__ = "lx";
pub const __UINT64_FMTX__ = "lX";
pub const __UINT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`");
// (no file):241:9
pub const __UINT64_C = @import("std").zig.c_translation.Macros.UL_SUFFIX;
pub const __UINT64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __INT64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST8_TYPE__ = i8;
pub const __INT_LEAST8_MAX__ = @as(c_int, 127);
pub const __INT_LEAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_LEAST8_FMTd__ = "hhd";
pub const __INT_LEAST8_FMTi__ = "hhi";
pub const __UINT_LEAST8_TYPE__ = u8;
pub const __UINT_LEAST8_MAX__ = @as(c_int, 255);
pub const __UINT_LEAST8_FMTo__ = "hho";
pub const __UINT_LEAST8_FMTu__ = "hhu";
pub const __UINT_LEAST8_FMTx__ = "hhx";
pub const __UINT_LEAST8_FMTX__ = "hhX";
pub const __INT_LEAST16_TYPE__ = c_short;
pub const __INT_LEAST16_MAX__ = @as(c_int, 32767);
pub const __INT_LEAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_LEAST16_FMTd__ = "hd";
pub const __INT_LEAST16_FMTi__ = "hi";
pub const __UINT_LEAST16_TYPE__ = c_ushort;
pub const __UINT_LEAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_LEAST16_FMTo__ = "ho";
pub const __UINT_LEAST16_FMTu__ = "hu";
pub const __UINT_LEAST16_FMTx__ = "hx";
pub const __UINT_LEAST16_FMTX__ = "hX";
pub const __INT_LEAST32_TYPE__ = c_int;
pub const __INT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_LEAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_LEAST32_FMTd__ = "d";
pub const __INT_LEAST32_FMTi__ = "i";
pub const __UINT_LEAST32_TYPE__ = c_uint;
pub const __UINT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_LEAST32_FMTo__ = "o";
pub const __UINT_LEAST32_FMTu__ = "u";
pub const __UINT_LEAST32_FMTx__ = "x";
pub const __UINT_LEAST32_FMTX__ = "X";
pub const __INT_LEAST64_TYPE__ = c_long;
pub const __INT_LEAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_LEAST64_FMTd__ = "ld";
pub const __INT_LEAST64_FMTi__ = "li";
pub const __UINT_LEAST64_TYPE__ = c_ulong;
pub const __UINT_LEAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINT_LEAST64_FMTo__ = "lo";
pub const __UINT_LEAST64_FMTu__ = "lu";
pub const __UINT_LEAST64_FMTx__ = "lx";
pub const __UINT_LEAST64_FMTX__ = "lX";
pub const __INT_FAST8_TYPE__ = i8;
pub const __INT_FAST8_MAX__ = @as(c_int, 127);
pub const __INT_FAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_FAST8_FMTd__ = "hhd";
pub const __INT_FAST8_FMTi__ = "hhi";
pub const __UINT_FAST8_TYPE__ = u8;
pub const __UINT_FAST8_MAX__ = @as(c_int, 255);
pub const __UINT_FAST8_FMTo__ = "hho";
pub const __UINT_FAST8_FMTu__ = "hhu";
pub const __UINT_FAST8_FMTx__ = "hhx";
pub const __UINT_FAST8_FMTX__ = "hhX";
pub const __INT_FAST16_TYPE__ = c_short;
pub const __INT_FAST16_MAX__ = @as(c_int, 32767);
pub const __INT_FAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_FAST16_FMTd__ = "hd";
pub const __INT_FAST16_FMTi__ = "hi";
pub const __UINT_FAST16_TYPE__ = c_ushort;
pub const __UINT_FAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_FAST16_FMTo__ = "ho";
pub const __UINT_FAST16_FMTu__ = "hu";
pub const __UINT_FAST16_FMTx__ = "hx";
pub const __UINT_FAST16_FMTX__ = "hX";
pub const __INT_FAST32_TYPE__ = c_int;
pub const __INT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_FAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_FAST32_FMTd__ = "d";
pub const __INT_FAST32_FMTi__ = "i";
pub const __UINT_FAST32_TYPE__ = c_uint;
pub const __UINT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_FAST32_FMTo__ = "o";
pub const __UINT_FAST32_FMTu__ = "u";
pub const __UINT_FAST32_FMTx__ = "x";
pub const __UINT_FAST32_FMTX__ = "X";
pub const __INT_FAST64_TYPE__ = c_long;
pub const __INT_FAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_FAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_FAST64_FMTd__ = "ld";
pub const __INT_FAST64_FMTi__ = "li";
pub const __UINT_FAST64_TYPE__ = c_ulong;
pub const __UINT_FAST64_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINT_FAST64_FMTo__ = "lo";
pub const __UINT_FAST64_FMTu__ = "lu";
pub const __UINT_FAST64_FMTx__ = "lx";
pub const __UINT_FAST64_FMTX__ = "lX";
pub const __USER_LABEL_PREFIX__ = "";
pub const __FINITE_MATH_ONLY__ = @as(c_int, 0);
pub const __GNUC_STDC_INLINE__ = @as(c_int, 1);
pub const __GCC_ATOMIC_TEST_AND_SET_TRUEVAL = @as(c_int, 1);
pub const __GCC_DESTRUCTIVE_SIZE = @as(c_int, 64);
pub const __GCC_CONSTRUCTIVE_SIZE = @as(c_int, 64);
pub const __CLANG_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __NO_INLINE__ = @as(c_int, 1);
pub const __PIC__ = @as(c_int, 2);
pub const __pic__ = @as(c_int, 2);
pub const __FLT_RADIX__ = @as(c_int, 2);
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __ELF__ = @as(c_int, 1);
pub const __GCC_ASM_FLAG_OUTPUTS__ = @as(c_int, 1);
pub const __code_model_small__ = @as(c_int, 1);
pub const __amd64__ = @as(c_int, 1);
pub const __amd64 = @as(c_int, 1);
pub const __x86_64 = @as(c_int, 1);
pub const __x86_64__ = @as(c_int, 1);
pub const __SEG_GS = @as(c_int, 1);
pub const __SEG_FS = @as(c_int, 1);
pub const __seg_gs = @compileError("unable to translate macro: undefined identifier `address_space`");
// (no file):375:9
pub const __seg_fs = @compileError("unable to translate macro: undefined identifier `address_space`");
// (no file):376:9
pub const __znver2 = @as(c_int, 1);
pub const __znver2__ = @as(c_int, 1);
pub const __tune_znver2__ = @as(c_int, 1);
pub const __REGISTER_PREFIX__ = "";
pub const __NO_MATH_INLINES = @as(c_int, 1);
pub const __AES__ = @as(c_int, 1);
pub const __PCLMUL__ = @as(c_int, 1);
pub const __LAHF_SAHF__ = @as(c_int, 1);
pub const __LZCNT__ = @as(c_int, 1);
pub const __RDRND__ = @as(c_int, 1);
pub const __FSGSBASE__ = @as(c_int, 1);
pub const __BMI__ = @as(c_int, 1);
pub const __BMI2__ = @as(c_int, 1);
pub const __POPCNT__ = @as(c_int, 1);
pub const __PRFCHW__ = @as(c_int, 1);
pub const __RDSEED__ = @as(c_int, 1);
pub const __ADX__ = @as(c_int, 1);
pub const __MOVBE__ = @as(c_int, 1);
pub const __SSE4A__ = @as(c_int, 1);
pub const __FMA__ = @as(c_int, 1);
pub const __F16C__ = @as(c_int, 1);
pub const __SHA__ = @as(c_int, 1);
pub const __FXSR__ = @as(c_int, 1);
pub const __XSAVE__ = @as(c_int, 1);
pub const __XSAVEOPT__ = @as(c_int, 1);
pub const __XSAVEC__ = @as(c_int, 1);
pub const __XSAVES__ = @as(c_int, 1);
pub const __CLFLUSHOPT__ = @as(c_int, 1);
pub const __CLWB__ = @as(c_int, 1);
pub const __CLZERO__ = @as(c_int, 1);
pub const __RDPID__ = @as(c_int, 1);
pub const __CRC32__ = @as(c_int, 1);
pub const __AVX2__ = @as(c_int, 1);
pub const __AVX__ = @as(c_int, 1);
pub const __SSE4_2__ = @as(c_int, 1);
pub const __SSE4_1__ = @as(c_int, 1);
pub const __SSSE3__ = @as(c_int, 1);
pub const __SSE3__ = @as(c_int, 1);
pub const __SSE2__ = @as(c_int, 1);
pub const __SSE2_MATH__ = @as(c_int, 1);
pub const __SSE__ = @as(c_int, 1);
pub const __SSE_MATH__ = @as(c_int, 1);
pub const __MMX__ = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_16 = @as(c_int, 1);
pub const __SIZEOF_FLOAT128__ = @as(c_int, 16);
pub const unix = @as(c_int, 1);
pub const __unix = @as(c_int, 1);
pub const __unix__ = @as(c_int, 1);
pub const linux = @as(c_int, 1);
pub const __linux = @as(c_int, 1);
pub const __linux__ = @as(c_int, 1);
pub const __gnu_linux__ = @as(c_int, 1);
pub const __FLOAT128__ = @as(c_int, 1);
pub const __STDC__ = @as(c_int, 1);
pub const __STDC_HOSTED__ = @as(c_int, 1);
pub const __STDC_VERSION__ = @as(c_long, 201710);
pub const __STDC_UTF_16__ = @as(c_int, 1);
pub const __STDC_UTF_32__ = @as(c_int, 1);
pub const __STDC_EMBED_NOT_FOUND__ = @as(c_int, 0);
pub const __STDC_EMBED_FOUND__ = @as(c_int, 1);
pub const __STDC_EMBED_EMPTY__ = @as(c_int, 2);
pub const __GLIBC_MINOR__ = @as(c_int, 35);
pub const __GCC_HAVE_DWARF2_CFI_ASM = @as(c_int, 1);
pub const RFIDCAPI3_H = "";
pub const RFIDAPI_TYPES_H = "";
pub const MAX_TAGS_IN_FILTER = @as(c_int, 256);
pub const MAX_NUM_EXTRA_TRIGGER = @as(c_int, 7);
pub const __CLANG_INTTYPES_H = "";
pub const _INTTYPES_H = @as(c_int, 1);
pub const _FEATURES_H = @as(c_int, 1);
pub const __KERNEL_STRICT_NAMES = "";
pub const __GLIBC__ = @as(c_int, 2);
pub inline fn __GLIBC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub inline fn __GNUC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub inline fn __glibc_clang_prereq(maj: anytype, min: anytype) @TypeOf(((__clang_major__ << @as(c_int, 16)) + __clang_minor__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__clang_major__ << @as(c_int, 16)) + __clang_minor__) >= ((maj << @as(c_int, 16)) + min);
}
pub const __GLIBC_USE = @compileError("unable to translate macro: undefined identifier `__GLIBC_USE_`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/features.h:199:9
pub const _DEFAULT_SOURCE = @as(c_int, 1);
pub const __GLIBC_USE_ISOC2Y = @as(c_int, 0);
pub const __GLIBC_USE_ISOC23 = @as(c_int, 0);
pub const __USE_ISOC11 = @as(c_int, 1);
pub const __USE_ISOC99 = @as(c_int, 1);
pub const __USE_ISOC95 = @as(c_int, 1);
pub const __USE_POSIX_IMPLICITLY = @as(c_int, 1);
pub const _POSIX_SOURCE = @as(c_int, 1);
pub const _POSIX_C_SOURCE = @as(c_long, 200809);
pub const __USE_POSIX = @as(c_int, 1);
pub const __USE_POSIX2 = @as(c_int, 1);
pub const __USE_POSIX199309 = @as(c_int, 1);
pub const __USE_POSIX199506 = @as(c_int, 1);
pub const __USE_XOPEN2K = @as(c_int, 1);
pub const __USE_XOPEN2K8 = @as(c_int, 1);
pub const _ATFILE_SOURCE = @as(c_int, 1);
pub const __WORDSIZE = @as(c_int, 64);
pub const __WORDSIZE_TIME64_COMPAT32 = @as(c_int, 1);
pub const __SYSCALL_WORDSIZE = @as(c_int, 64);
pub const __TIMESIZE = __WORDSIZE;
pub const __USE_TIME_BITS64 = @as(c_int, 1);
pub const __USE_MISC = @as(c_int, 1);
pub const __USE_ATFILE = @as(c_int, 1);
pub const __USE_FORTIFY_LEVEL = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_GETS = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_SCANF = @as(c_int, 0);
pub const __GLIBC_USE_C23_STRTOL = @as(c_int, 0);
pub const _STDC_PREDEF_H = @as(c_int, 1);
pub const __STDC_IEC_559__ = @as(c_int, 1);
pub const __STDC_IEC_60559_BFP__ = @as(c_long, 201404);
pub const __STDC_IEC_559_COMPLEX__ = @as(c_int, 1);
pub const __STDC_IEC_60559_COMPLEX__ = @as(c_long, 201404);
pub const __STDC_ISO_10646__ = @as(c_long, 201706);
pub const __GNU_LIBRARY__ = @as(c_int, 6);
pub const _SYS_CDEFS_H = @as(c_int, 1);
pub const __glibc_has_attribute = @compileError("unable to translate macro: undefined identifier `__has_attribute`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:45:10
pub inline fn __glibc_has_builtin(name: anytype) @TypeOf(__has_builtin(name)) {
    _ = &name;
    return __has_builtin(name);
}
pub const __glibc_has_extension = @compileError("unable to translate macro: undefined identifier `__has_extension`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:55:10
pub const __LEAF = "";
pub const __LEAF_ATTR = "";
pub const __THROW = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:79:11
pub const __THROWNL = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:80:11
pub const __NTH = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:81:11
pub const __NTHNL = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:82:11
pub const __COLD = @compileError("unable to translate macro: undefined identifier `__cold__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:102:11
pub inline fn __P(args: anytype) @TypeOf(args) {
    _ = &args;
    return args;
}
pub inline fn __PMT(args: anytype) @TypeOf(args) {
    _ = &args;
    return args;
}
pub const __CONCAT = @compileError("unable to translate C expr: unexpected token '##'");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:131:9
pub const __STRING = @compileError("unable to translate C expr: unexpected token '#'");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:132:9
pub const __ptr_t = ?*anyopaque;
pub const __BEGIN_DECLS = "";
pub const __END_DECLS = "";
pub const __attribute_overloadable__ = @compileError("unable to translate macro: undefined identifier `__overloadable__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:151:10
pub inline fn __bos(ptr: anytype) @TypeOf(__builtin_object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1))) {
    _ = &ptr;
    return __builtin_object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1));
}
pub inline fn __bos0(ptr: anytype) @TypeOf(__builtin_object_size(ptr, @as(c_int, 0))) {
    _ = &ptr;
    return __builtin_object_size(ptr, @as(c_int, 0));
}
pub inline fn __glibc_objsize0(__o: anytype) @TypeOf(__bos0(__o)) {
    _ = &__o;
    return __bos0(__o);
}
pub inline fn __glibc_objsize(__o: anytype) @TypeOf(__bos(__o)) {
    _ = &__o;
    return __bos(__o);
}
pub const __warnattr = @compileError("unable to translate C expr: unexpected token ''");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:370:10
pub const __errordecl = @compileError("unable to translate C expr: unexpected token 'extern'");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:371:10
pub const __flexarr = @compileError("unable to translate C expr: unexpected token '['");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:379:10
pub const __glibc_c99_flexarr_available = @as(c_int, 1);
pub const __REDIRECT = @compileError("unable to translate C expr: unexpected token '__asm__'");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:410:10
pub const __REDIRECT_NTH = @compileError("unable to translate C expr: unexpected token '__asm__'");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:417:11
pub const __REDIRECT_NTHNL = @compileError("unable to translate C expr: unexpected token '__asm__'");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:419:11
pub const __ASMNAME = @compileError("unable to translate C expr: unexpected token ','");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:422:10
pub inline fn __ASMNAME2(prefix: anytype, cname: anytype) @TypeOf(__STRING(prefix) ++ cname) {
    _ = &prefix;
    _ = &cname;
    return __STRING(prefix) ++ cname;
}
pub const __REDIRECT_FORTIFY = __REDIRECT;
pub const __REDIRECT_FORTIFY_NTH = __REDIRECT_NTH;
pub const __attribute_malloc__ = @compileError("unable to translate macro: undefined identifier `__malloc__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:452:10
pub const __attribute_alloc_size__ = @compileError("unable to translate C expr: unexpected token ''");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:463:10
pub const __attribute_alloc_align__ = @compileError("unable to translate macro: undefined identifier `__alloc_align__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:469:10
pub const __attribute_pure__ = @compileError("unable to translate macro: undefined identifier `__pure__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:479:10
pub const __attribute_const__ = @compileError("unable to translate C expr: unexpected token '__attribute__'");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:486:10
pub const __attribute_maybe_unused__ = @compileError("unable to translate macro: undefined identifier `__unused__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:492:10
pub const __attribute_used__ = @compileError("unable to translate macro: undefined identifier `__used__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:501:10
pub const __attribute_noinline__ = @compileError("unable to translate macro: undefined identifier `__noinline__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:502:10
pub const __attribute_deprecated__ = @compileError("unable to translate macro: undefined identifier `__deprecated__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:510:10
pub const __attribute_deprecated_msg__ = @compileError("unable to translate macro: undefined identifier `__deprecated__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:520:10
pub const __attribute_format_arg__ = @compileError("unable to translate macro: undefined identifier `__format_arg__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:533:10
pub const __attribute_format_strfmon__ = @compileError("unable to translate macro: undefined identifier `__format__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:543:10
pub const __attribute_nonnull__ = @compileError("unable to translate macro: undefined identifier `__nonnull__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:555:11
pub inline fn __nonnull(params: anytype) @TypeOf(__attribute_nonnull__(params)) {
    _ = &params;
    return __attribute_nonnull__(params);
}
pub const __returns_nonnull = @compileError("unable to translate macro: undefined identifier `__returns_nonnull__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:568:10
pub const __attribute_warn_unused_result__ = @compileError("unable to translate macro: undefined identifier `__warn_unused_result__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:577:10
pub const __wur = "";
pub const __always_inline = @compileError("unable to translate macro: undefined identifier `__always_inline__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:595:10
pub const __attribute_artificial__ = @compileError("unable to translate macro: undefined identifier `__artificial__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:604:10
pub const __extern_inline = @compileError("unable to translate macro: undefined identifier `__gnu_inline__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:622:11
pub const __extern_always_inline = @compileError("unable to translate macro: undefined identifier `__gnu_inline__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:623:11
pub const __fortify_function = __extern_always_inline ++ __attribute_artificial__;
pub const __restrict_arr = @compileError("unable to translate C expr: unexpected token '__restrict'");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:666:10
pub inline fn __glibc_unlikely(cond: anytype) @TypeOf(__builtin_expect(cond, @as(c_int, 0))) {
    _ = &cond;
    return __builtin_expect(cond, @as(c_int, 0));
}
pub inline fn __glibc_likely(cond: anytype) @TypeOf(__builtin_expect(cond, @as(c_int, 1))) {
    _ = &cond;
    return __builtin_expect(cond, @as(c_int, 1));
}
pub const __attribute_nonstring__ = "";
pub const __attribute_copy__ = @compileError("unable to translate C expr: unexpected token ''");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:715:10
pub const __LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = @as(c_int, 0);
pub inline fn __LDBL_REDIR1(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR(name: anytype, proto: anytype) @TypeOf(name ++ proto) {
    _ = &name;
    _ = &proto;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR1_NTH(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return name ++ proto ++ __THROW;
}
pub inline fn __LDBL_REDIR_NTH(name: anytype, proto: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = &name;
    _ = &proto;
    return name ++ proto ++ __THROW;
}
pub const __LDBL_REDIR2_DECL = @compileError("unable to translate C expr: unexpected token ''");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:792:10
pub const __LDBL_REDIR_DECL = @compileError("unable to translate C expr: unexpected token ''");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:793:10
pub inline fn __REDIRECT_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT(name, proto, alias)) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return __REDIRECT(name, proto, alias);
}
pub inline fn __REDIRECT_NTH_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT_NTH(name, proto, alias)) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return __REDIRECT_NTH(name, proto, alias);
}
pub const __glibc_macro_warning1 = @compileError("unable to translate macro: undefined identifier `_Pragma`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:807:10
pub const __glibc_macro_warning = @compileError("unable to translate macro: undefined identifier `GCC`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:808:10
pub const __HAVE_GENERIC_SELECTION = @as(c_int, 1);
pub const __fortified_attr_access = @compileError("unable to translate C expr: unexpected token ''");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:853:11
pub const __attr_access = @compileError("unable to translate C expr: unexpected token ''");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:854:11
pub const __attr_access_none = @compileError("unable to translate C expr: unexpected token ''");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:855:11
pub const __attr_dealloc = @compileError("unable to translate C expr: unexpected token ''");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:865:10
pub const __attr_dealloc_free = "";
pub const __attribute_returns_twice__ = @compileError("unable to translate macro: undefined identifier `__returns_twice__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:872:10
pub const __attribute_struct_may_alias__ = @compileError("unable to translate macro: undefined identifier `__may_alias__`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/sys/cdefs.h:881:10
pub const __stub___compat_bdflush = "";
pub const __stub_chflags = "";
pub const __stub_fchflags = "";
pub const __stub_gtty = "";
pub const __stub_revoke = "";
pub const __stub_setlogin = "";
pub const __stub_sigreturn = "";
pub const __stub_stty = "";
pub const __CLANG_STDINT_H = "";
pub const _STDINT_H = @as(c_int, 1);
pub const __GLIBC_INTERNAL_STARTING_HEADER_IMPLEMENTATION = "";
pub const __GLIBC_USE_LIB_EXT2 = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_BFP_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_BFP_EXT_C23 = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT_C23 = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_TYPES_EXT = @as(c_int, 0);
pub const _BITS_TYPES_H = @as(c_int, 1);
pub const __S16_TYPE = c_short;
pub const __U16_TYPE = c_ushort;
pub const __S32_TYPE = c_int;
pub const __U32_TYPE = c_uint;
pub const __SLONGWORD_TYPE = c_long;
pub const __ULONGWORD_TYPE = c_ulong;
pub const __SQUAD_TYPE = c_long;
pub const __UQUAD_TYPE = c_ulong;
pub const __SWORD_TYPE = c_long;
pub const __UWORD_TYPE = c_ulong;
pub const __SLONG32_TYPE = c_int;
pub const __ULONG32_TYPE = c_uint;
pub const __S64_TYPE = c_long;
pub const __U64_TYPE = c_ulong;
pub const __STD_TYPE = @compileError("unable to translate C expr: unexpected token 'typedef'");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/types.h:137:10
pub const _BITS_TYPESIZES_H = @as(c_int, 1);
pub const __SYSCALL_SLONG_TYPE = __SLONGWORD_TYPE;
pub const __SYSCALL_ULONG_TYPE = __ULONGWORD_TYPE;
pub const __DEV_T_TYPE = __UQUAD_TYPE;
pub const __UID_T_TYPE = __U32_TYPE;
pub const __GID_T_TYPE = __U32_TYPE;
pub const __INO_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __INO64_T_TYPE = __UQUAD_TYPE;
pub const __MODE_T_TYPE = __U32_TYPE;
pub const __NLINK_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSWORD_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF64_T_TYPE = __SQUAD_TYPE;
pub const __PID_T_TYPE = __S32_TYPE;
pub const __RLIM_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __RLIM64_T_TYPE = __UQUAD_TYPE;
pub const __BLKCNT_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __BLKCNT64_T_TYPE = __SQUAD_TYPE;
pub const __FSBLKCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSBLKCNT64_T_TYPE = __UQUAD_TYPE;
pub const __FSFILCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSFILCNT64_T_TYPE = __UQUAD_TYPE;
pub const __ID_T_TYPE = __U32_TYPE;
pub const __CLOCK_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __TIME_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __USECONDS_T_TYPE = __U32_TYPE;
pub const __SUSECONDS_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __SUSECONDS64_T_TYPE = __SQUAD_TYPE;
pub const __DADDR_T_TYPE = __S32_TYPE;
pub const __KEY_T_TYPE = __S32_TYPE;
pub const __CLOCKID_T_TYPE = __S32_TYPE;
pub const __TIMER_T_TYPE = ?*anyopaque;
pub const __BLKSIZE_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __FSID_T_TYPE = @compileError("unable to translate macro: undefined identifier `__val`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/x86-linux-gnu/bits/typesizes.h:73:9
pub const __SSIZE_T_TYPE = __SWORD_TYPE;
pub const __CPU_MASK_TYPE = __SYSCALL_ULONG_TYPE;
pub const __OFF_T_MATCHES_OFF64_T = @as(c_int, 1);
pub const __INO_T_MATCHES_INO64_T = @as(c_int, 1);
pub const __RLIM_T_MATCHES_RLIM64_T = @as(c_int, 1);
pub const __STATFS_MATCHES_STATFS64 = @as(c_int, 1);
pub const __KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64 = @as(c_int, 1);
pub const __FD_SETSIZE = @as(c_int, 1024);
pub const _BITS_TIME64_H = @as(c_int, 1);
pub const __TIME64_T_TYPE = __TIME_T_TYPE;
pub const _BITS_WCHAR_H = @as(c_int, 1);
pub const __WCHAR_MAX = __WCHAR_MAX__;
pub const __WCHAR_MIN = -__WCHAR_MAX - @as(c_int, 1);
pub const _BITS_STDINT_INTN_H = @as(c_int, 1);
pub const _BITS_STDINT_UINTN_H = @as(c_int, 1);
pub const _BITS_STDINT_LEAST_H = @as(c_int, 1);
pub const __intptr_t_defined = "";
pub const INT8_MIN = -@as(c_int, 128);
pub const INT16_MIN = -@as(c_int, 32767) - @as(c_int, 1);
pub const INT32_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const INT64_MIN = -__INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT8_MAX = @as(c_int, 127);
pub const INT16_MAX = @as(c_int, 32767);
pub const INT32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const INT64_MAX = __INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT8_MAX = @as(c_int, 255);
pub const UINT16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT64_MAX = __UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INT_LEAST8_MIN = -@as(c_int, 128);
pub const INT_LEAST16_MIN = -@as(c_int, 32767) - @as(c_int, 1);
pub const INT_LEAST32_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const INT_LEAST64_MIN = -__INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT_LEAST8_MAX = @as(c_int, 127);
pub const INT_LEAST16_MAX = @as(c_int, 32767);
pub const INT_LEAST32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const INT_LEAST64_MAX = __INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT_LEAST8_MAX = @as(c_int, 255);
pub const UINT_LEAST16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT_LEAST32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT_LEAST64_MAX = __UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INT_FAST8_MIN = -@as(c_int, 128);
pub const INT_FAST16_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INT_FAST32_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INT_FAST64_MIN = -__INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT_FAST8_MAX = @as(c_int, 127);
pub const INT_FAST16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const INT_FAST32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const INT_FAST64_MAX = __INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT_FAST8_MAX = @as(c_int, 255);
pub const UINT_FAST16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_FAST32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_FAST64_MAX = __UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INTPTR_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INTPTR_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const UINTPTR_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const INTMAX_MIN = -__INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INTMAX_MAX = __INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINTMAX_MAX = __UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const PTRDIFF_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const PTRDIFF_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const SIG_ATOMIC_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const SIG_ATOMIC_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const SIZE_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const WCHAR_MIN = __WCHAR_MIN;
pub const WCHAR_MAX = __WCHAR_MAX;
pub const WINT_MIN = @as(c_uint, 0);
pub const WINT_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub inline fn INT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn INT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn INT32_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const INT64_C = @import("std").zig.c_translation.Macros.L_SUFFIX;
pub inline fn UINT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn UINT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const UINT32_C = @import("std").zig.c_translation.Macros.U_SUFFIX;
pub const UINT64_C = @import("std").zig.c_translation.Macros.UL_SUFFIX;
pub const INTMAX_C = @import("std").zig.c_translation.Macros.L_SUFFIX;
pub const UINTMAX_C = @import("std").zig.c_translation.Macros.UL_SUFFIX;
pub const ____gwchar_t_defined = @as(c_int, 1);
pub const __PRI64_PREFIX = "l";
pub const __PRIPTR_PREFIX = "l";
pub const PRId8 = "d";
pub const PRId16 = "d";
pub const PRId32 = "d";
pub const PRId64 = __PRI64_PREFIX ++ "d";
pub const PRIdLEAST8 = "d";
pub const PRIdLEAST16 = "d";
pub const PRIdLEAST32 = "d";
pub const PRIdLEAST64 = __PRI64_PREFIX ++ "d";
pub const PRIdFAST8 = "d";
pub const PRIdFAST16 = __PRIPTR_PREFIX ++ "d";
pub const PRIdFAST32 = __PRIPTR_PREFIX ++ "d";
pub const PRIdFAST64 = __PRI64_PREFIX ++ "d";
pub const PRIi8 = "i";
pub const PRIi16 = "i";
pub const PRIi32 = "i";
pub const PRIi64 = __PRI64_PREFIX ++ "i";
pub const PRIiLEAST8 = "i";
pub const PRIiLEAST16 = "i";
pub const PRIiLEAST32 = "i";
pub const PRIiLEAST64 = __PRI64_PREFIX ++ "i";
pub const PRIiFAST8 = "i";
pub const PRIiFAST16 = __PRIPTR_PREFIX ++ "i";
pub const PRIiFAST32 = __PRIPTR_PREFIX ++ "i";
pub const PRIiFAST64 = __PRI64_PREFIX ++ "i";
pub const PRIo8 = "o";
pub const PRIo16 = "o";
pub const PRIo32 = "o";
pub const PRIo64 = __PRI64_PREFIX ++ "o";
pub const PRIoLEAST8 = "o";
pub const PRIoLEAST16 = "o";
pub const PRIoLEAST32 = "o";
pub const PRIoLEAST64 = __PRI64_PREFIX ++ "o";
pub const PRIoFAST8 = "o";
pub const PRIoFAST16 = __PRIPTR_PREFIX ++ "o";
pub const PRIoFAST32 = __PRIPTR_PREFIX ++ "o";
pub const PRIoFAST64 = __PRI64_PREFIX ++ "o";
pub const PRIu8 = "u";
pub const PRIu16 = "u";
pub const PRIu32 = "u";
pub const PRIu64 = __PRI64_PREFIX ++ "u";
pub const PRIuLEAST8 = "u";
pub const PRIuLEAST16 = "u";
pub const PRIuLEAST32 = "u";
pub const PRIuLEAST64 = __PRI64_PREFIX ++ "u";
pub const PRIuFAST8 = "u";
pub const PRIuFAST16 = __PRIPTR_PREFIX ++ "u";
pub const PRIuFAST32 = __PRIPTR_PREFIX ++ "u";
pub const PRIuFAST64 = __PRI64_PREFIX ++ "u";
pub const PRIx8 = "x";
pub const PRIx16 = "x";
pub const PRIx32 = "x";
pub const PRIx64 = __PRI64_PREFIX ++ "x";
pub const PRIxLEAST8 = "x";
pub const PRIxLEAST16 = "x";
pub const PRIxLEAST32 = "x";
pub const PRIxLEAST64 = __PRI64_PREFIX ++ "x";
pub const PRIxFAST8 = "x";
pub const PRIxFAST16 = __PRIPTR_PREFIX ++ "x";
pub const PRIxFAST32 = __PRIPTR_PREFIX ++ "x";
pub const PRIxFAST64 = __PRI64_PREFIX ++ "x";
pub const PRIX8 = "X";
pub const PRIX16 = "X";
pub const PRIX32 = "X";
pub const PRIX64 = __PRI64_PREFIX ++ "X";
pub const PRIXLEAST8 = "X";
pub const PRIXLEAST16 = "X";
pub const PRIXLEAST32 = "X";
pub const PRIXLEAST64 = __PRI64_PREFIX ++ "X";
pub const PRIXFAST8 = "X";
pub const PRIXFAST16 = __PRIPTR_PREFIX ++ "X";
pub const PRIXFAST32 = __PRIPTR_PREFIX ++ "X";
pub const PRIXFAST64 = __PRI64_PREFIX ++ "X";
pub const PRIdMAX = __PRI64_PREFIX ++ "d";
pub const PRIiMAX = __PRI64_PREFIX ++ "i";
pub const PRIoMAX = __PRI64_PREFIX ++ "o";
pub const PRIuMAX = __PRI64_PREFIX ++ "u";
pub const PRIxMAX = __PRI64_PREFIX ++ "x";
pub const PRIXMAX = __PRI64_PREFIX ++ "X";
pub const PRIdPTR = __PRIPTR_PREFIX ++ "d";
pub const PRIiPTR = __PRIPTR_PREFIX ++ "i";
pub const PRIoPTR = __PRIPTR_PREFIX ++ "o";
pub const PRIuPTR = __PRIPTR_PREFIX ++ "u";
pub const PRIxPTR = __PRIPTR_PREFIX ++ "x";
pub const PRIXPTR = __PRIPTR_PREFIX ++ "X";
pub const SCNd8 = "hhd";
pub const SCNd16 = "hd";
pub const SCNd32 = "d";
pub const SCNd64 = __PRI64_PREFIX ++ "d";
pub const SCNdLEAST8 = "hhd";
pub const SCNdLEAST16 = "hd";
pub const SCNdLEAST32 = "d";
pub const SCNdLEAST64 = __PRI64_PREFIX ++ "d";
pub const SCNdFAST8 = "hhd";
pub const SCNdFAST16 = __PRIPTR_PREFIX ++ "d";
pub const SCNdFAST32 = __PRIPTR_PREFIX ++ "d";
pub const SCNdFAST64 = __PRI64_PREFIX ++ "d";
pub const SCNi8 = "hhi";
pub const SCNi16 = "hi";
pub const SCNi32 = "i";
pub const SCNi64 = __PRI64_PREFIX ++ "i";
pub const SCNiLEAST8 = "hhi";
pub const SCNiLEAST16 = "hi";
pub const SCNiLEAST32 = "i";
pub const SCNiLEAST64 = __PRI64_PREFIX ++ "i";
pub const SCNiFAST8 = "hhi";
pub const SCNiFAST16 = __PRIPTR_PREFIX ++ "i";
pub const SCNiFAST32 = __PRIPTR_PREFIX ++ "i";
pub const SCNiFAST64 = __PRI64_PREFIX ++ "i";
pub const SCNu8 = "hhu";
pub const SCNu16 = "hu";
pub const SCNu32 = "u";
pub const SCNu64 = __PRI64_PREFIX ++ "u";
pub const SCNuLEAST8 = "hhu";
pub const SCNuLEAST16 = "hu";
pub const SCNuLEAST32 = "u";
pub const SCNuLEAST64 = __PRI64_PREFIX ++ "u";
pub const SCNuFAST8 = "hhu";
pub const SCNuFAST16 = __PRIPTR_PREFIX ++ "u";
pub const SCNuFAST32 = __PRIPTR_PREFIX ++ "u";
pub const SCNuFAST64 = __PRI64_PREFIX ++ "u";
pub const SCNo8 = "hho";
pub const SCNo16 = "ho";
pub const SCNo32 = "o";
pub const SCNo64 = __PRI64_PREFIX ++ "o";
pub const SCNoLEAST8 = "hho";
pub const SCNoLEAST16 = "ho";
pub const SCNoLEAST32 = "o";
pub const SCNoLEAST64 = __PRI64_PREFIX ++ "o";
pub const SCNoFAST8 = "hho";
pub const SCNoFAST16 = __PRIPTR_PREFIX ++ "o";
pub const SCNoFAST32 = __PRIPTR_PREFIX ++ "o";
pub const SCNoFAST64 = __PRI64_PREFIX ++ "o";
pub const SCNx8 = "hhx";
pub const SCNx16 = "hx";
pub const SCNx32 = "x";
pub const SCNx64 = __PRI64_PREFIX ++ "x";
pub const SCNxLEAST8 = "hhx";
pub const SCNxLEAST16 = "hx";
pub const SCNxLEAST32 = "x";
pub const SCNxLEAST64 = __PRI64_PREFIX ++ "x";
pub const SCNxFAST8 = "hhx";
pub const SCNxFAST16 = __PRIPTR_PREFIX ++ "x";
pub const SCNxFAST32 = __PRIPTR_PREFIX ++ "x";
pub const SCNxFAST64 = __PRI64_PREFIX ++ "x";
pub const SCNdMAX = __PRI64_PREFIX ++ "d";
pub const SCNiMAX = __PRI64_PREFIX ++ "i";
pub const SCNoMAX = __PRI64_PREFIX ++ "o";
pub const SCNuMAX = __PRI64_PREFIX ++ "u";
pub const SCNxMAX = __PRI64_PREFIX ++ "x";
pub const SCNdPTR = __PRIPTR_PREFIX ++ "d";
pub const SCNiPTR = __PRIPTR_PREFIX ++ "i";
pub const SCNoPTR = __PRIPTR_PREFIX ++ "o";
pub const SCNuPTR = __PRIPTR_PREFIX ++ "u";
pub const SCNxPTR = __PRIPTR_PREFIX ++ "x";
pub const _WCHAR_H = @as(c_int, 1);
pub const _BITS_FLOATN_H = "";
pub const __HAVE_FLOAT128 = @as(c_int, 1);
pub const __HAVE_DISTINCT_FLOAT128 = @as(c_int, 1);
pub const __HAVE_FLOAT64X = @as(c_int, 1);
pub const __HAVE_FLOAT64X_LONG_DOUBLE = @as(c_int, 1);
pub const __f128 = @compileError("unable to translate macro: undefined identifier `q`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/x86-linux-gnu/bits/floatn.h:70:12
pub const __CFLOAT128 = __cfloat128;
pub const __builtin_signbitf128 = @compileError("unable to translate macro: undefined identifier `__signbitf128`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/x86-linux-gnu/bits/floatn.h:124:12
pub const _BITS_FLOATN_COMMON_H = "";
pub const __HAVE_FLOAT16 = @as(c_int, 0);
pub const __HAVE_FLOAT32 = @as(c_int, 1);
pub const __HAVE_FLOAT64 = @as(c_int, 1);
pub const __HAVE_FLOAT32X = @as(c_int, 1);
pub const __HAVE_FLOAT128X = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT16 = __HAVE_FLOAT16;
pub const __HAVE_DISTINCT_FLOAT32 = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT64 = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT32X = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT64X = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT128X = __HAVE_FLOAT128X;
pub const __HAVE_FLOAT128_UNLIKE_LDBL = (__HAVE_DISTINCT_FLOAT128 != 0) and (__LDBL_MANT_DIG__ != @as(c_int, 113));
pub const __HAVE_FLOATN_NOT_TYPEDEF = @as(c_int, 0);
pub const __f32 = @import("std").zig.c_translation.Macros.F_SUFFIX;
pub inline fn __f64(x: anytype) @TypeOf(x) {
    _ = &x;
    return x;
}
pub inline fn __f32x(x: anytype) @TypeOf(x) {
    _ = &x;
    return x;
}
pub const __f64x = @import("std").zig.c_translation.Macros.L_SUFFIX;
pub const __CFLOAT32 = @compileError("unable to translate: TODO _Complex");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:149:12
pub const __CFLOAT64 = @compileError("unable to translate: TODO _Complex");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:160:13
pub const __CFLOAT32X = @compileError("unable to translate: TODO _Complex");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:169:12
pub const __CFLOAT64X = @compileError("unable to translate: TODO _Complex");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:178:13
pub inline fn __builtin_huge_valf32() @TypeOf(__builtin_huge_valf()) {
    return __builtin_huge_valf();
}
pub inline fn __builtin_inff32() @TypeOf(__builtin_inff()) {
    return __builtin_inff();
}
pub inline fn __builtin_nanf32(x: anytype) @TypeOf(__builtin_nanf(x)) {
    _ = &x;
    return __builtin_nanf(x);
}
pub const __builtin_nansf32 = @compileError("unable to translate macro: undefined identifier `__builtin_nansf`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:221:12
pub const __builtin_huge_valf64 = @compileError("unable to translate macro: undefined identifier `__builtin_huge_val`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:255:13
pub const __builtin_inff64 = @compileError("unable to translate macro: undefined identifier `__builtin_inf`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:256:13
pub const __builtin_nanf64 = @compileError("unable to translate macro: undefined identifier `__builtin_nan`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:257:13
pub const __builtin_nansf64 = @compileError("unable to translate macro: undefined identifier `__builtin_nans`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:258:13
pub const __builtin_huge_valf32x = @compileError("unable to translate macro: undefined identifier `__builtin_huge_val`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:272:12
pub const __builtin_inff32x = @compileError("unable to translate macro: undefined identifier `__builtin_inf`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:273:12
pub const __builtin_nanf32x = @compileError("unable to translate macro: undefined identifier `__builtin_nan`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:274:12
pub const __builtin_nansf32x = @compileError("unable to translate macro: undefined identifier `__builtin_nans`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:275:12
pub const __builtin_huge_valf64x = @compileError("unable to translate macro: undefined identifier `__builtin_huge_vall`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:289:13
pub const __builtin_inff64x = @compileError("unable to translate macro: undefined identifier `__builtin_infl`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:290:13
pub const __builtin_nanf64x = @compileError("unable to translate macro: undefined identifier `__builtin_nanl`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:291:13
pub const __builtin_nansf64x = @compileError("unable to translate macro: undefined identifier `__builtin_nansl`");
// /opt/zig-x86_64-linux-0.15.2/lib/libc/include/generic-glibc/bits/floatn-common.h:292:13
pub const __need_size_t = "";
pub const __need_wchar_t = "";
pub const __need_NULL = "";
pub const _SIZE_T = "";
pub const _WCHAR_T = "";
pub const NULL = @import("std").zig.c_translation.cast(?*anyopaque, @as(c_int, 0));
pub const __need___va_list = "";
pub const __GNUC_VA_LIST = "";
pub const _VA_LIST_DEFINED = "";
pub const __wint_t_defined = @as(c_int, 1);
pub const _WINT_T = @as(c_int, 1);
pub const __mbstate_t_defined = @as(c_int, 1);
pub const ____mbstate_t_defined = @as(c_int, 1);
pub const ____FILE_defined = @as(c_int, 1);
pub const __FILE_defined = @as(c_int, 1);
pub const _BITS_TYPES_LOCALE_T_H = @as(c_int, 1);
pub const _BITS_TYPES___LOCALE_T_H = @as(c_int, 1);
pub const WEOF = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 0xffffffff, .hex);
pub const __attr_dealloc_fclose = "";
pub const MAX_PATH = @as(c_int, 260);
pub const WINAPI = @compileError("unable to translate macro: undefined identifier `stdcall`");
// /home/rfidlab/Developer/hackathon-rfid/apps/host-app/zig-rfid-queue/../linux64_sdk/include/rfidapiTypes.h:55:9
pub const FALSE = @as(c_int, 0);
pub const TRUE = @as(c_int, 1);
pub const RFIDAPI_CONSTANTS_H = "";
pub const NUM_LOCK_DATA_FIELDS = @as(c_int, 5);
pub const RFIDAPI_STRUCTS_H = "";
pub const RFIDAPI_ERRORS_H = "";
pub const RFID_Connect = RFID_ConnectA;
pub const RFID_GetDllVersionInfo = RFID_GetDllVersionInfoA;
pub const RFID_GetReaderCaps = RFID_GetReaderCapsA;
pub const RFID_AddZone = RFID_AddZoneA;
pub const RFID_GetCustomParams = RFID_GetCustomParamsA;
pub const RFID_SetCustomParams = RFID_SetCustomParamsA;
pub const RFID_Login = RFID_LoginA;
pub const RFID_ExportProfileToReader = RFID_ExportProfileToReaderA;
pub const RFID_InstallUserApp = RFID_InstallUserAppA;
pub const RFID_UninstallUserApp = RFID_UninstallUserAppA;
pub const RFID_StartUserApp = RFID_StartUserAppA;
pub const RFID_StopUserApp = RFID_StopUserAppA;
pub const RFID_GetUserAppRunStatus = RFID_GetUserAppRunStatusA;
pub const RFID_ListUserApps = RFID_ListUserAppsA;
pub const RFID_SetUserAppAutoStart = RFID_SetUserAppAutoStartA;
pub const RFID_ImportProfileFromReader = RFID_ImportProfileFromReaderA;
pub const RFID_GetProfileList = RFID_GetProfileListA;
pub const RFID_SetActiveProfile = RFID_SetActiveProfileA;
pub const RFID_DeleteProfile = RFID_DeleteProfileA;
pub const RFID_UpdateSoftware = RFID_UpdateSoftwareA;
pub const RFID_UpdateRadioFirmware = RFID_UpdateRadioFirmwareA;
pub const RFID_AcquireLicenseOnLine = RFID_AcquireLicenseOnLineA;
pub const RFID_AcquireLicenseOffLine = RFID_AcquireLicenseOffLineA;
pub const RFID_ReturnLicense = RFID_ReturnLicenseA;
pub const RFID_GetAvailableLicenses = RFID_GetAvailableLicensesA;
pub const RFID_UpdateRadioConfig = RFID_UpdateRadioConfigA;
pub const RFID_GetUpdateStatus = RFID_GetUpdateStatusA;
pub const RFID_GetSystemInfo = RFID_GetSystemInfoA;
pub const RFID_GetNetworkInterfaceSettings = RFID_GetNetworkInterfaceSettingsA;
pub const RFID_SetNetworkInterfaceSettings = RFID_SetNetworkInterfaceSettingsA;
pub const RFID_SetReaderInfo = RFID_SetReaderInfoA;
pub const RFID_GetReaderInfo = RFID_GetReaderInfoA;
pub const RFID_GetTimeZoneList = RFID_GetTimeZoneListA;
pub const RFID_GetLLRPConnectionConfig = RFID_GetLLRPConnectionConfigA;
pub const RFID_SetLLRPConnectionConfig = RFID_SetLLRPConnectionConfigA;
pub const RFID_GetLLRPConnectionStatus = RFID_GetLLRPConnectionStatusA;
pub const RFID_GetErrorDescription = RFID_GetErrorDescriptionA;
pub const RFID_GetLastErrorInfo = RFID_GetLastErrorInfoA;
pub const RFID_GetSupportedRegionList = RFID_GetSupportedRegionListA;
pub const RFID_GetRegionStandardList = RFID_GetRegionStandardListA;
pub const RFID_SetActiveRegion = RFID_SetActiveRegionA;
pub const RFID_GetActiveRegionInfo = RFID_GetActiveRegionInfoA;
pub const RFID_GetActiveRegionStandardInfo = RFID_GetActiveRegionStandardInfoA;
pub const RFID_ChangePassword = RFID_ChangePasswordA;
pub const RFID_SetNTPServer = RFID_SetNTPServerA;
pub const RFID_GetNTPServer = RFID_GetNTPServerA;
pub const RFID_SetSysLogServer = RFID_SetSysLogServerA;
pub const RFID_GetSysLogServer = RFID_GetSysLogServerA;
pub const RFID_SetWirelessNetwork = RFID_SetWirelessNetworkA;
pub const RFID_GetWirelessConfigParameters = RFID_GetWirelessConfigParametersA;
pub const RFID_GetTemperatureStatus = RFID_GetTemperatureStatusA;
pub const RFID_GetFilesToUpdate = RFID_GetFilesToUpdateA;
pub const RFID_GetUpdatePartitionStatus = RFID_GetUpdatePartitionStatusA;
pub const _IO_FILE = struct__IO_FILE;
pub const __locale_struct = struct___locale_struct;
pub const tm = struct_tm;
pub const _SYSTEMTIME = struct__SYSTEMTIME;
pub const _RFID_VERSION = enum__RFID_VERSION;
pub const _RFID_EVENT_TYPE = enum__RFID_EVENT_TYPE;
pub const _READER_EXCEPTION_EVENT_TYPE = enum__READER_EXCEPTION_EVENT_TYPE;
pub const _DISCONNECTION_EVENT_TYPE = enum__DISCONNECTION_EVENT_TYPE;
pub const _ANTENNA_EVENT_TYPE = enum__ANTENNA_EVENT_TYPE;
pub const _GPI_PORT_STATE = enum__GPI_PORT_STATE;
pub const _HANDHELD_TRIGGER_EVENT_TYPE = enum__HANDHELD_TRIGGER_EVENT_TYPE;
pub const _READER_ID_TYPE = enum__READER_ID_TYPE;
pub const _FORWARD_LINK_MODULATION = enum__FORWARD_LINK_MODULATION;
pub const _MODULATION = enum__MODULATION;
pub const _DIVIDE_RATIO = enum__DIVIDE_RATIO;
pub const _SPECTRAL_MASK_INDICATOR = enum__SPECTRAL_MASK_INDICATOR;
pub const _COMMUNICATION_STANDARD = enum__COMMUNICATION_STANDARD;
pub const _MEMORY_BANK = enum__MEMORY_BANK;
pub const _START_TRIGGER_TYPE = enum__START_TRIGGER_TYPE;
pub const _STOP_TRIGGER_TYPE = enum__STOP_TRIGGER_TYPE;
pub const _TRUNCATE_ACTION = enum__TRUNCATE_ACTION;
pub const _SESSION = enum__SESSION;
pub const _INVENTORY_STATE = enum__INVENTORY_STATE;
pub const _FILTER_ACTION = enum__FILTER_ACTION;
pub const _SL_FLAG = enum__SL_FLAG;
pub const _TARGET = enum__TARGET;
pub const _STATE_UNAWARE_ACTION = enum__STATE_UNAWARE_ACTION;
pub const _STATE_AWARE_ACTION = enum__STATE_AWARE_ACTION;
pub const _LOCK_PRIVILEGE = enum__LOCK_PRIVILEGE;
pub const _LOCK_DATA_FIELD = enum__LOCK_DATA_FIELD;
pub const _RECOMMISSION_OPERATION_CODE = enum__RECOMMISSION_OPERATION_CODE;
pub const _TID_HIDE_STATE = enum__TID_HIDE_STATE;
pub const _TAG_OPERATING_RANGE = enum__TAG_OPERATING_RANGE;
pub const _ANTENNA_MODE = enum__ANTENNA_MODE;
pub const _ACCESS_OPERATION_CODE = enum__ACCESS_OPERATION_CODE;
pub const _TAG_FIELD = enum__TAG_FIELD;
pub const _RFSURVEY_FIELD = enum__RFSURVEY_FIELD;
pub const _TAG_EVENT = enum__TAG_EVENT;
pub const _TAG_EVENT_REPORT_TRIGGER = enum__TAG_EVENT_REPORT_TRIGGER;
pub const _TAG_MOVING_EVENT_REPORT = enum__TAG_MOVING_EVENT_REPORT;
pub const _READER_TYPE = enum__READER_TYPE;
pub const _MATCH_PATTERN = enum__MATCH_PATTERN;
pub const _MATCH_RANGE = enum__MATCH_RANGE;
pub const _MATCH_TAG_LIST = enum__MATCH_TAG_LIST;
pub const _TRACE_LEVEL = enum__TRACE_LEVEL;
pub const _READER_ID_LENGTH = enum__READER_ID_LENGTH;
pub const _SERVICE_ID = enum__SERVICE_ID;
pub const _HEALTH_STATUS = enum__HEALTH_STATUS;
pub const _USB_OPERATION_MODE = enum__USB_OPERATION_MODE;
pub const _POWER_SOURCE_TYPE = enum__POWER_SOURCE_TYPE;
pub const _POWER_NEGOTIATION_STATUS = enum__POWER_NEGOTIATION_STATUS;
pub const _LED_COLOR = enum__LED_COLOR;
pub const _OPERATION_QUALIFIER = enum__OPERATION_QUALIFIER;
pub const _TEMPERATURE_SOURCE = enum__TEMPERATURE_SOURCE;
pub const _ALARM_LEVEL = enum__ALARM_LEVEL;
pub const _ANTENNA_STOP_TRIGGER_TYPE = enum__ANTENNA_STOP_TRIGGER_TYPE;
pub const _BATTERY_STATUS = enum__BATTERY_STATUS;
pub const _RADIO_TRANSMIT_DELAY_TYPE = enum__RADIO_TRANSMIT_DELAY_TYPE;
pub const _RFID_PARAM_TYPE = enum__RFID_PARAM_TYPE;
pub const _SMART_ALGORITHM_SELECTOR = enum__SMART_ALGORITHM_SELECTOR;
pub const _MLT_TAG_STATE = enum__MLT_TAG_STATE;
pub const _MLT_READER_TYPE = enum__MLT_READER_TYPE;
pub const _RFID_STATUS = enum__RFID_STATUS;
pub const _ACCESS_OPERATION_STATUS = enum__ACCESS_OPERATION_STATUS;
pub const _SEC_CONNECTION_INFO = struct__SEC_CONNECTION_INFO;
pub const _CONNECTION_INFO = struct__CONNECTION_INFO;
pub const _SERVER_INFO = struct__SERVER_INFO;
pub const _ANTENNA_INFO = struct__ANTENNA_INFO;
pub const _LOCATION_INFO = struct__LOCATION_INFO;
pub const _GPS_LOCATION = struct__GPS_LOCATION;
pub const _MLT_LOCATION_REPORT = struct__MLT_LOCATION_REPORT;
pub const _MLT_TAG_READ_REPORT = struct__MLT_TAG_READ_REPORT;
pub const _MLT_TRANSITION_REPORT = struct__MLT_TRANSITION_REPORT;
pub const _MLT_READER_PARAMSW = struct__MLT_READER_PARAMSW;
pub const _MLT_READER_PARAMSA = struct__MLT_READER_PARAMSA;
pub const _MLT_ALGORITHM_REPORT = struct__MLT_ALGORITHM_REPORT;
pub const _MLT_TIMEWINDOWSIZE_PARAMS = struct__MLT_TIMEWINDOWSIZE_PARAMS;
pub const _MLT_TIMELIMIT_PARAMS = struct__MLT_TIMELIMIT_PARAMS;
pub const _MLT_ANTENNA_MAP_TABLE = struct__MLT_ANTENNA_MAP_TABLE;
pub const _MLT_TRANSITION_SLOPETABLE = struct__MLT_TRANSITION_SLOPETABLE;
pub const _MLT_ALGORITHM_PARAMS = struct__MLT_ALGORITHM_PARAMS;
pub const _IMPINJ_QT_DATA = struct__IMPINJ_QT_DATA;
pub const _IMPINJ_QT_WRITE_PARAMS = struct__IMPINJ_QT_WRITE_PARAMS;
pub const _IMPINJ_QT_READ_PARMS = struct__IMPINJ_QT_READ_PARMS;
pub const _NXP_CHANGE_CONFIG_PARAMS = struct__NXP_CHANGE_CONFIG_PARAMS;
pub const _ACCESS_OPERATION_RESULT = struct__ACCESS_OPERATION_RESULT;
pub const _STATE_AWARE_SINGULATION_ACTION = struct__STATE_AWARE_SINGULATION_ACTION;
pub const _SINGULATION_CONTROL = struct__SINGULATION_CONTROL;
pub const _PERSISTENCE_CONFIG = struct__PERSISTENCE_CONFIG;
pub const _RF_MODE_TABLE_ENTRY = struct__RF_MODE_TABLE_ENTRY;
pub const _UHF_RF_MODE_TABLE = struct__UHF_RF_MODE_TABLE;
pub const _RF_MODES = struct__RF_MODES;
pub const _TRANSMIT_POWER_LEVEL_TABLE = struct__TRANSMIT_POWER_LEVEL_TABLE;
pub const _RECEIVE_SENSITIVITY_TABLE = struct__RECEIVE_SENSITIVITY_TABLE;
pub const _DUTY_CYCLE_TABLE = struct__DUTY_CYCLE_TABLE;
pub const _FREQ_HOP_TABLE = struct__FREQ_HOP_TABLE;
pub const _FREQ_HOP_INFO = struct__FREQ_HOP_INFO;
pub const _FIXED_FREQ_INFO = struct__FIXED_FREQ_INFO;
pub const _PER_ANTENNA_RECEIVE_SENSITIVITY_RANGE = struct__PER_ANTENNA_RECEIVE_SENSITIVITY_RANGE;
pub const _READER_IDW = struct__READER_IDW;
pub const _READER_IDA = struct__READER_IDA;
pub const _VERSIONW = struct__VERSIONW;
pub const _VERSIONA = struct__VERSIONA;
pub const _READER_MODULE_VERSIONSW = struct__READER_MODULE_VERSIONSW;
pub const _READER_MODULE_VERSIONSA = struct__READER_MODULE_VERSIONSA;
pub const _GPI_TRIGGER = struct__GPI_TRIGGER;
pub const _HANDHELD_TRIGGER = struct__HANDHELD_TRIGGER;
pub const _TIMEOFDAY = struct__TIMEOFDAY;
pub const _TIMELAPSE_START_TRIGGER = struct__TIMELAPSE_START_TRIGGER;
pub const _DISTANCE_TRIGGER = struct__DISTANCE_TRIGGER;
pub const _TIMELAPSE_STOP_TRIGGER = struct__TIMELAPSE_STOP_TRIGGER;
pub const _TRIGGER_WITH_TIMEOUT = struct__TRIGGER_WITH_TIMEOUT;
pub const _PERIODIC_TRIGGER = struct__PERIODIC_TRIGGER;
pub const _START_TRIGGER = struct__START_TRIGGER;
pub const _STOP_TRIGGER = struct__STOP_TRIGGER;
pub const _EXTRA_TRIGGER_INFO = struct__EXTRA_TRIGGER_INFO;
pub const _STOP_TRIGGER_RFSURVEY = struct__STOP_TRIGGER_RFSURVEY;
pub const _TAG_EVENT_REPORT_INFO = struct__TAG_EVENT_REPORT_INFO;
pub const _REPORT_TRIGGERS = struct__REPORT_TRIGGERS;
pub const _TRIGGER_INFO = struct__TRIGGER_INFO;
pub const _TAG_ZONE_INFOW = struct__TAG_ZONE_INFOW;
pub const _TAG_ZONE_INFOA = struct__TAG_ZONE_INFOA;
pub const _TAG_DATA = struct__TAG_DATA;
pub const _RF_SURVEY_DATA = struct__RF_SURVEY_DATA;
pub const _TAG_STORAGE_SETTINGS = struct__TAG_STORAGE_SETTINGS;
pub const _RFSURVEY_STORAGE_SETTINGS = struct__RFSURVEY_STORAGE_SETTINGS;
pub const _DISCONNECTION_EVENT_DATA = struct__DISCONNECTION_EVENT_DATA;
pub const _READER_EXCEPTION_EVENT_DATAW = struct__READER_EXCEPTION_EVENT_DATAW;
pub const _READER_EXCEPTION_EVENT_DATAA = struct__READER_EXCEPTION_EVENT_DATAA;
pub const _ANTENNA_EVENT_DATA = struct__ANTENNA_EVENT_DATA;
pub const _GPI_EVENT_DATA = struct__GPI_EVENT_DATA;
pub const _HANDHELD_EVENT_DATA = struct__HANDHELD_EVENT_DATA;
pub const _NXP_EAS_ALARM_DATA = struct__NXP_EAS_ALARM_DATA;
pub const _DEBUG_INFO_DATAW = struct__DEBUG_INFO_DATAW;
pub const _DEBUG_INFO_DATAA = struct__DEBUG_INFO_DATAA;
pub const _TEMPERATURE_ALARM_DATA = struct__TEMPERATURE_ALARM_DATA;
pub const _STATE_AWARE_ACTION_PARAMS = struct__STATE_AWARE_ACTION_PARAMS;
pub const _PRE_FILTER = struct__PRE_FILTER;
pub const _PRE_FILTER_LIST = struct__PRE_FILTER_LIST;
pub const _ANTENNA_STOP_TRIGGER = struct__ANTENNA_STOP_TRIGGER;
pub const _ANTENNA_RF_CONFIG = struct__ANTENNA_RF_CONFIG;
pub const _ANTENNA_CONFIG = struct__ANTENNA_CONFIG;
pub const _ZONE_CONFIGW = struct__ZONE_CONFIGW;
pub const _ZONE_CONFIGA = struct__ZONE_CONFIGA;
pub const _ZONE_INFO = struct__ZONE_INFO;
pub const _DEBUG_INFO_PARAMS = struct__DEBUG_INFO_PARAMS;
pub const _ZONE_SEQUENCE = struct__ZONE_SEQUENCE;
pub const _TAG_PATTERN = struct__TAG_PATTERN;
pub const _RSSI_RANGE_FILTER = struct__RSSI_RANGE_FILTER;
pub const _TAG_LIST_FILTER = struct__TAG_LIST_FILTER;
pub const _POST_FILTER = struct__POST_FILTER;
pub const _ACCESS_FILTER = struct__ACCESS_FILTER;
pub const _READ_ACCESS_PARAMS = struct__READ_ACCESS_PARAMS;
pub const _WRITE_ACCESS_PARAMS = struct__WRITE_ACCESS_PARAMS;
pub const _WRITE_SPECIFIC_FIELD_ACCESS_PARAMS = struct__WRITE_SPECIFIC_FIELD_ACCESS_PARAMS;
pub const _KILL_ACCESS_PARAMS = struct__KILL_ACCESS_PARAMS;
pub const _LOCK_ACCESS_PARAMS = struct__LOCK_ACCESS_PARAMS;
pub const _BLOCK_ERASE_ACCESS_PARAMS = struct__BLOCK_ERASE_ACCESS_PARAMS;
pub const _RECOMMISSION_ACCESS_PARAMS = struct__RECOMMISSION_ACCESS_PARAMS;
pub const _BLOCK_PERMALOCK_ACCESS_PARAMS = struct__BLOCK_PERMALOCK_ACCESS_PARAMS;
pub const _AUTHENTICATE_ACCESS_PARAMS = struct__AUTHENTICATE_ACCESS_PARAMS;
pub const _READBUFFER_ACCESS_PARAMS = struct__READBUFFER_ACCESS_PARAMS;
pub const _UNTRACEABLE_ACCESS_PARAMS = struct__UNTRACEABLE_ACCESS_PARAMS;
pub const _CRYPTO_ACCESS_PARAMS = struct__CRYPTO_ACCESS_PARAMS;
pub const _OP_CODE_PARAMS = struct__OP_CODE_PARAMS;
pub const _READER_STATS = struct__READER_STATS;
pub const _VERSION_INFOW = struct__VERSION_INFOW;
pub const _VERSION_INFOA = struct__VERSION_INFOA;
pub const _LOGIN_INFOW = struct__LOGIN_INFOW;
pub const _FTPSERVER_INFOW = struct__FTPSERVER_INFOW;
pub const _LOGIN_INFOA = struct__LOGIN_INFOA;
pub const _FTPSERVER_INFOA = struct__FTPSERVER_INFOA;
pub const _UPDATE_STATUSW = struct__UPDATE_STATUSW;
pub const _UPDATE_STATUSA = struct__UPDATE_STATUSA;
pub const _UPDATE_PARTITION_STATUSW = struct__UPDATE_PARTITION_STATUSW;
pub const _UPDATE_PARTITION_STATUSA = struct__UPDATE_PARTITION_STATUSA;
pub const _TIME_SERVER_INFOW = struct__TIME_SERVER_INFOW;
pub const _TIME_SERVER_INFOA = struct__TIME_SERVER_INFOA;
pub const _SYSLOG_SERVER_INFOW = struct__SYSLOG_SERVER_INFOW;
pub const _SYSLOG_SERVER_INFOA = struct__SYSLOG_SERVER_INFOA;
pub const _WIRELESS_CONFIGURED_PARAMETERSW = struct__WIRELESS_CONFIGURED_PARAMETERSW;
pub const _WIRELESS_CONFIGURED_PARAMETERSA = struct__WIRELESS_CONFIGURED_PARAMETERSA;
pub const _READER_INFOW = struct__READER_INFOW;
pub const _READER_INFOA = struct__READER_INFOA;
pub const _READER_NETWORK_INFOW = struct__READER_NETWORK_INFOW;
pub const _READER_DEVICE_INFOW = struct__READER_DEVICE_INFOW;
pub const _READER_SYSTEM_INFOW = struct__READER_SYSTEM_INFOW;
pub const _READER_NETWORK_INFOA = struct__READER_NETWORK_INFOA;
pub const _READER_DEVICE_INFOA = struct__READER_DEVICE_INFOA;
pub const _READER_SYSTEM_INFOA = struct__READER_SYSTEM_INFOA;
pub const _PROFILE_LISTW = struct__PROFILE_LISTW;
pub const _PROFILE_LISTA = struct__PROFILE_LISTA;
pub const _LICENSE_INFOW = struct__LICENSE_INFOW;
pub const _LICENSE_INFOA = struct__LICENSE_INFOA;
pub const _LICENSE_LISTW = struct__LICENSE_LISTW;
pub const _LICENSE_LISTA = struct__LICENSE_LISTA;
pub const _TIME_ZONE_LISTW = struct__TIME_ZONE_LISTW;
pub const _TIME_ZONE_LISTA = struct__TIME_ZONE_LISTA;
pub const _FILE_UPDATE_LISTW = struct__FILE_UPDATE_LISTW;
pub const _FILE_UPDATE_LISTA = struct__FILE_UPDATE_LISTA;
pub const _SEC_LLRP_CONFIG = struct__SEC_LLRP_CONFIG;
pub const _LLRP_CONNECTION_STATUSW = struct__LLRP_CONNECTION_STATUSW;
pub const _LLRP_CONNECTION_STATUSA = struct__LLRP_CONNECTION_STATUSA;
pub const _LLRP_CONNECTION_CONFIGW = struct__LLRP_CONNECTION_CONFIGW;
pub const _LLRP_CONNECTION_CONFIGA = struct__LLRP_CONNECTION_CONFIGA;
pub const _USB_OPERATION_INFO = struct__USB_OPERATION_INFO;
pub const _LED_INFO = struct__LED_INFO;
pub const _ERROR_INFOW = struct__ERROR_INFOW;
pub const _ERROR_INFOA = struct__ERROR_INFOA;
pub const _NXP_SET_EAS_PARAMS = struct__NXP_SET_EAS_PARAMS;
pub const _NXP_READ_PROTECT_PARAMS = struct__NXP_READ_PROTECT_PARAMS;
pub const _NXP_RESET_READ_PROTECT_PARAMS = struct__NXP_RESET_READ_PROTECT_PARAMS;
pub const _FUJITSU_CHANGE_WORDLOCK_ACCESS_PARAMS = struct__FUJITSU_CHANGE_WORDLOCK_ACCESS_PARAMS;
pub const _FUJITSU_CHANGE_BLOCKLOCK_ACCESS_PARAMS = struct__FUJITSU_CHANGE_BLOCKLOCK_ACCESS_PARAMS;
pub const _FUJITSU_READ_BLOCKLOCK_ACCESS_PARAMS = struct__FUJITSU_READ_BLOCKLOCK_ACCESS_PARAMS;
pub const _FUJITSU_BURST_WRITE_ACCESS_PARAMS = struct__FUJITSU_BURST_WRITE_ACCESS_PARAMS;
pub const _FUJITSU_BURSTERASE_ACCESS_PARAMS = struct__FUJITSU_BURSTERASE_ACCESS_PARAMS;
pub const _FUJITSU_AREA_READLOCK_ACCESS_PARAMS = struct__FUJITSU_AREA_READLOCK_ACCESS_PARAMS;
pub const _FUJITSU_AREA_WRITELOCK_ACCESS_PARAMS = struct__FUJITSU_AREA_WRITELOCK_ACCESS_PARAMS;
pub const _FUJITSU_AREA_WRITELOCK_WOPASSWORD_ACCESS_PARAMS = struct__FUJITSU_AREA_WRITELOCK_WOPASSWORD_ACCESS_PARAMS;
pub const _FUJITSU_CHANGE_BLOCK_OR_AREA_GROUPPASSWORD_ACCESS_PARAMS = struct__FUJITSU_CHANGE_BLOCK_OR_AREA_GROUPPASSWORD_ACCESS_PARAMS;
pub const _USERAPP_DATAW = struct__USERAPP_DATAW;
pub const _USERAPP_LISTW = struct__USERAPP_LISTW;
pub const _USERAPP_DATAA = struct__USERAPP_DATAA;
pub const _USERAPP_LISTA = struct__USERAPP_LISTA;
pub const _CABLE_LOSS_COMPENSATION_ = struct__CABLE_LOSS_COMPENSATION_;
pub const _SLED_BATTERY_STATUS = struct__SLED_BATTERY_STATUS;
pub const _STANDARD_REGION_INFOW = struct__STANDARD_REGION_INFOW;
pub const _STANDARD_REGION_INFOA = struct__STANDARD_REGION_INFOA;
pub const _USER_INFOW = struct__USER_INFOW;
pub const _USER_INFOA = struct__USER_INFOA;
pub const _ACTIVE_REGION_INFOW = struct__ACTIVE_REGION_INFOW;
pub const _ACTIVE_REGION_INFOA = struct__ACTIVE_REGION_INFOA;
pub const _REGION_LISTW = struct__REGION_LISTW;
pub const _REGION_LISTA = struct__REGION_LISTA;
pub const _STANDARD_INFO_LISTW = struct__STANDARD_INFO_LISTW;
pub const _STANDARD_INFO_LISTA = struct__STANDARD_INFO_LISTA;
pub const _CHANNEL_LIST = struct__CHANNEL_LIST;
pub const _TEMPERATURE_STATUS_W = struct__TEMPERATURE_STATUS_W;
pub const _TEMPERATURE_STATUS_A = struct__TEMPERATURE_STATUS_A;
pub const _IOT_CLOUD_INFOW = struct__IOT_CLOUD_INFOW;
pub const _IOT_CLOUD_INFOA = struct__IOT_CLOUD_INFOA;
pub const _SMART_ALGORITHM_PARAMS = struct__SMART_ALGORITHM_PARAMS;
