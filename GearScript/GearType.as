namespace GearType
{
    // 装备种类：
    // 头盔
    // 护甲
    // 背包
    // 手套
    // 枪套
    array<string> GearSlotType =
    {
        "Helmet",
        "Armor",
        "Backpack",
        "Glove",
        "Holster"
    };

    // 装备质量-乘数 （最终数值 = 随机数值 * 装备质量乘数）
    // 普通-25%
    // 精良-50%
    // 稀有-75%
    // 顶级-100%
    array<array<string>> GearQuality = 
    {
        {"Common", 0.25},
        {"Superior", 0.5},
        {"Rare", 0.75},
        {"High-end", 1.0}
    };
}