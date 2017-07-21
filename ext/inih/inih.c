#include "inih.h"

VALUE mINIH = Qnil;

static int mINIH_ini_handler(void *data, const char *sect, const char *name, const char *val);

/*
    @overload parse(string)
        Parse an INI-formatted string into a Hash.
        @param string [String] the INI-formatted string to parse
        @return [Hash] the resulting hash
        @raise [RuntimeError] if a parse error occurs
*/
static VALUE mINIH_parse(VALUE self, VALUE string);

/*
    @overload load(filename)
        Parse an INI-formatted file into a Hash.
        @param filename [String] the INI-formatted file to parse
        @return [Hash] the resulting hash
        @raise [RuntimeError] if a parse or I/O error occurs
*/
static VALUE mINIH_load(VALUE self, VALUE filename);

void Init_inih()
{
    mINIH = rb_define_module("INIH");

    rb_define_singleton_method(mINIH, "parse", mINIH_parse, 1);
    rb_define_singleton_method(mINIH, "load", mINIH_load, 1);
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

static VALUE mINIH_parse(VALUE self, VALUE string)
{
    char *str = StringValueCStr(string);
    VALUE hash = rb_hash_new();
    int result;

    if ((result = ini_parse_string(str, mINIH_ini_handler, &hash)) != 0) {
        rb_raise(rb_eRuntimeError, "parse error, line %d", result);
    }

    return rb_funcall(mINIH, rb_intern("normalize"), 1, hash);
}

static VALUE mINIH_load(VALUE self, VALUE filename)
{
    char *file = StringValueCStr(filename);
    VALUE hash = rb_hash_new();
    int result;

    if ((result = ini_parse(file, mINIH_ini_handler, &hash)) != 0) {
        if (result < 0) {
            rb_raise(rb_eRuntimeError, "I/O error");
        }
        else {
            rb_raise(rb_eRuntimeError, "parse error, line %d", result);
        }
    }

    return rb_funcall(mINIH, rb_intern("normalize"), 1, hash);
}
