package dmon

when ODIN_OS == .Windows {
    when ODIN_DEBUG == true {
        foreign import dmon_lib "dmond.lib"
    }
    else {
        foreign import dmon_lib "dmon.lib"
    }
} else when ODIN_OS == .Darwin {
    foreign import dmon_lib "dmon.a"
}

Watch_Flag :: enum i32 {
  Recursive = 0x1,
  Symlinks = 0x2,
  Out_Of_Scope_Links = 0x4, // TODO: Not implemented yet
  Ignore_Directories = 0x8, // TODO: Not implemented yet
}

Watch_Flags :: bit_set[Watch_Flag]

Action :: enum i32 {
  Create = 1,
  Delete,
  Modify,
  Move,
}

Watch_Id :: struct {
  id: u32,
}

Watch_Event_Callback :: proc "c" (watch_id: Watch_Id, action: Action, rootdir: cstring, filepath: cstring, old_filepath: cstring, user_data: rawptr)

@(default_calling_convention="c", link_prefix="dmon_")
foreign dmon_lib {
  init :: proc "c" () ---
  deinit :: proc "c" () ---
  watch :: proc "c" (rootdir: cstring, watch_cb: Watch_Event_Callback, flags: u32, user_data: rawptr) -> Watch_Id ---
  unwatch :: proc(id: Watch_Id) ---
}
