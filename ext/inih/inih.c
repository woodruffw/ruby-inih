#include "inih.h"

VALUE mINIH = Qnil;
VALUE cParseError = Qnil;

static int mINIH_ini_handler(void *data, const char *sect, const char *name, const char *val);

/*
    @overload parse_intern(string, normalize)
    @api private
*/
static VALUE mINIH_parse_intern(VALUE self, VALUE string, VALUE normalize);

/*
    @overload load_intern(filename, normalize)
    @api private
*/
static VALUE mINIH_load_intern(VALUE self, VALUE filename, VALUE normalize);

void Init_inih()
{
    mINIH = rb_define_module("INIH");
    cParseError = rb_const_get(mINIH, rb_intern("ParseError"));

    rb_define_singleton_method(mINIH, "parse_intern", mINIH_parse_intern, 2);
    rb_define_singleton_method(mINIH, "load_intern", mINIH_load_intern, 2);
}

static int mINIH_ini_handler(void *data, const char *sect, const char *name, const char *val)
{
    VALUE sect_s = rb_str_new_cstr(sect);
    VALUE name_s = rb_str_new_cstr(name);
    VALUE hash = *((VALUE *) data);
    VALUE subh = rb_hash_aref(hash, sect_s);

    if (NIL_P(subh)) {
        subh = rb_hash_new();
    }

    rb_hash_aset(subh, name_s, rb_str_new_cstr(val));
    rb_hash_aset(hash, sect_s, subh);

    return 1;
}

static VALUE mINIH_parse_intern(VALUE self, VALUE string, VALUE normalize)
{
    char *str = StringValueCStr(string);
    VALUE hash = rb_hash_new();
    int result;

    if ((result = ini_parse_string(str, mINIH_ini_handler, &hash)) != 0) {
        rb_raise(cParseError, "parse error, line %d", result);
    }

    if (normalize) {
        return rb_funcall(mINIH, rb_intern("normalize_hash"), 1, hash);
    }
    else {
        return hash;
    }
}

static VALUE mINIH_load_intern(VALUE self, VALUE filename, VALUE normalize)
{
    char *file = StringValueCStr(filename);
    VALUE hash = rb_hash_new();
    int result;

    if ((result = ini_parse(file, mINIH_ini_handler, &hash)) != 0) {
        if (result < 0) {
            rb_raise(rb_eIOError, "I/O error");
        }
        else {
            rb_raise(cParseError, "parse error, line %d", result);
        }
    }

    if (normalize) {
        return rb_funcall(mINIH, rb_intern("normalize_hash"), 1, hash);
    }
    else {
        return hash;
    }
}
