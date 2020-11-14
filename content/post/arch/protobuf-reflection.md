---
title: "protobuf 中的反射接口"
date: 2020-01-09T14:35:02+08:00
tags:
    - discover
    - consul
categories:
    - arch
comment: false
draft: true
---

## 简介 ##

Potobuf 是序列化的工具，可以用在其它的地方

## 案例 ##

### 设计思路 ###

## 细节分析 ##

### Reflection ###

### FieldDescriptor ###

### Message ###

### Plugin ###

插件机制，根据官方的文档。

模型为父子模型，plugin调用具体的 exe。





```cpp
int ReflectionBuilder::DeserializeMessage(std::string_view&& field_str,
                                          google::protobuf::Message* message) {
    StringTokenizer tok;
    // noempty
    tok.CharsTokenize(field_str, "\t", true);
    return DeserializeMessage(tok, message);
}
int ReflectionBuilder::DeserializeMessage(const StringTokenizer&     tok,
                                          google::protobuf::Message* message) {
    using namespace google::protobuf;
    const Reflection* reflection = message->GetReflection();
    const Descriptor* descriptor = message->GetDescriptor();
    for (int i = 0; i < descriptor->field_count(); ++i) {
        const FieldDescriptor* field = descriptor->field(i);
        int  tag_num = field->number();
        if (tag_num > tok.Size()) {
            break;
        }
        if (field->is_repeated()) {
            DeserializeRepeatedField(field, reflection, tok[tag_num - 1], message);
        } else {
            DeserializeSingleField(field, reflection, tok[tag_num - 1], message);
        }
    }
    return 0;
}
bool ReflectionBuilder::DeserializeSingleField(
    const google::protobuf::FieldDescriptor* field,
    const google::protobuf::Reflection*      reflection,
    const Token&                             tok_item,
    google::protobuf::Message*               message) {
    using namespace google::protobuf;
    FieldDescriptor::CppType cpp_type = field->cpp_type();
    switch (cpp_type) {
#define CASE_FILED_TYPE_DUMPER(                                                \
    enum_type, method, message, field, reflection, tok_item)                   \
    case FieldDescriptor::CPPTYPE_##enum_type: {                               \
        if (tok_item.Length()) {                                               \
            reflection->Set##method(message, field, tok_item.method());        \
        }                                                                      \
        break;                                                                 \
    }
        CASE_FILED_TYPE_DUMPER(
            INT32, Int32, message, field, reflection, tok_item)
        CASE_FILED_TYPE_DUMPER(
            UINT32, UInt32, message, field, reflection, tok_item)
        CASE_FILED_TYPE_DUMPER(
            INT64, Int64, message, field, reflection, tok_item)
        CASE_FILED_TYPE_DUMPER(
            UINT64, UInt64, message, field, reflection, tok_item)
        CASE_FILED_TYPE_DUMPER(
            DOUBLE, Double, message, field, reflection, tok_item)
        CASE_FILED_TYPE_DUMPER(
            FLOAT, Float, message, field, reflection, tok_item)
        CASE_FILED_TYPE_DUMPER(
            STRING, String, message, field, reflection, tok_item)
        CASE_FILED_TYPE_DUMPER(BOOL, Bool, message, field, reflection, tok_item)
#undef CASE_FILED_TYPE_DUMPER
    case FieldDescriptor::CPPTYPE_ENUM: {
        break;
    }
    case FieldDescriptor::CPPTYPE_MESSAGE: {
        if (tok_item.Length()) {
            Message* new_message = reflection->MutableMessage(message, field);
            std::string dump_str;
            DeserializeMessageField(field,
                                new_message->GetReflection(),
                                tok_item.String(),
                                new_message);
        }
        break;
    }
    } // end-switch
    return true;
}
bool ReflectionBuilder::DeserializeMessageField(
    const google::protobuf::FieldDescriptor* field,
    const google::protobuf::Reflection*      reflection,
    std::string_view&&                       field_str,
    google::protobuf::Message*               message) {
    using namespace google::protobuf;
    StringTokenizer tok;
    tok.CharsTokenize(field_str, ",", true);
    return DeserializeMessage(tok, message);
}
bool ReflectionBuilder::DeserializeRepeatedField(
    const google::protobuf::FieldDescriptor* field,
    const google::protobuf::Reflection*      reflection,
    const Token&                             tok_item,
    google::protobuf::Message*               message) {
    return DeserializeRepeatedField(
        field, reflection, tok_item.StringView(), message);
}
bool ReflectionBuilder::DeserializeRepeatedField(
    const google::protobuf::FieldDescriptor* field,
    const google::protobuf::Reflection*      reflection,
    std::string_view&&                       field_str,
    google::protobuf::Message*               message) {
    using namespace google::protobuf;
    StringTokenizer tok;
    // noempty
    tok.CharsTokenize(field_str, ";", true);
    FieldDescriptor::CppType cpp_type = field->cpp_type();
    switch (cpp_type) {
#define CASE_FILED_TYPE_DUMPER(                                                \
    enum_type, method, message, field, reflection, tok)                        \
    case FieldDescriptor::CPPTYPE_##enum_type: {                               \
        for (int i = 0; i < tok.Size(); ++i) {                                 \
            if (tok[i].Length()) {                                             \
                reflection->Add##method(message, field, tok[i].method());      \
            }                                                                  \
        }                                                                      \
        break;                                                                 \
    }
        CASE_FILED_TYPE_DUMPER(INT32, Int32, message, field, reflection, tok)
        CASE_FILED_TYPE_DUMPER(UINT32, UInt32, message, field, reflection, tok)
        CASE_FILED_TYPE_DUMPER(INT64, Int64, message, field, reflection, tok)
        CASE_FILED_TYPE_DUMPER(UINT64, UInt64, message, field, reflection, tok)
        CASE_FILED_TYPE_DUMPER(DOUBLE, Double, message, field, reflection, tok)
        CASE_FILED_TYPE_DUMPER(FLOAT, Float, message, field, reflection, tok)
        CASE_FILED_TYPE_DUMPER(STRING, String, message, field, reflection, tok)
        CASE_FILED_TYPE_DUMPER(BOOL, Bool, message, field, reflection, tok)
#undef CASE_FILED_TYPE_DUMPER
    case FieldDescriptor::CPPTYPE_ENUM: {
        break;
    }
    case FieldDescriptor::CPPTYPE_MESSAGE: {
        for (int i = 0; i < tok.Size(); ++i) {
            if (tok[i].Length()) {
                Message* new_message = reflection->AddMessage(message, field);
                DeserializeMessageField(field,
                                    new_message->GetReflection(),
                                    tok[i].StringView(),
                                    new_message);
            }
            break;
        }
    }
    } // end-switch
    return true;
}
```



## 总结 ##

