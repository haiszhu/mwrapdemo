use std::os::raw::{c_double, c_int};

#[no_mangle]
pub extern "C" fn rust_sin(n: c_int, x: *const c_double, y: *mut c_double) {
    if n <= 0 || x.is_null() || y.is_null() {
        return;
    }
    let n = n as usize;
    unsafe {
        let xs = std::slice::from_raw_parts(x, n);
        let ys = std::slice::from_raw_parts_mut(y, n);
        for i in 0..n {
            ys[i] = xs[i].sin();
        }
    }
}
