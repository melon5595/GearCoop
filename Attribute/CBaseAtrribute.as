//这里是玩家词条属性的基类，一个实例就是玩家的一种属性
enum ATTRIVUTE_VALTYPE
{
    VAL_NULL = -1,
    VAL_INT,
    VAL_FLOAT,
    VAL_UINT,
    VAL_BOOL,
    VAL_STRING,
    VAL_REF
}
class CBaseAttributeValue
{
    int iInt;
    float flFloat;
    uint uiUint;
    bool bBool;
    string szString;
    ref refRef;
}

abstract class CBaseAttribute
{
    string Name;
    int ValType;
    CBaseAttributeValue Value;

    void Change(CBasePlayer@ pPlayer, int _int)
    {
        //改变属性引发的方法
    }
}