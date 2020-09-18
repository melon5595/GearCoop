/**
abcl文件
文件名 SteamID.abcl
/*用于保存基础类型的自定义数值
iXX 整数型
flXX 浮点型
szXX 字符串型
vecXX 三维坐标
vec2XX 二维坐标
bXX 布尔值
aryiXXX 整数数组
aryszXXX 字符串数组
别的不存

不存在-即库存装备

[已装备的栏位-栏位.装备名称]
{
	变量名称=123
	变量名称=123
	变量名称=123
	变量名称=123
}

[栏位.装备名称]
{
	变量名称=123;
	变量名称=123;
	变量名称=123;
	变量名称=123;
}
**/


namespace GearFileIO
{
	void ReadExcetipon(string a, string b, string c)
	{
		g_Log.PrintF("在%1行%2发现错误, 原因: %3.", a, b, c);
	}

	CPlayerData@ Readabcl(string szPath)
	{
		File@ file = g_FileSystem.OpenFile(szPath, OpenFile::READ);
		if(file !is null && file.IsOpen()) 
		{
			bool bInSection = false;
			bool bInContent = false;
			CPlayerData pData;
			array<CBaseGear@> aryTempPlayerInventory = {};
			string szTemp;
			uint uiLine = 1;
			while(!file.EOFReached()) 
			{
				szTemp = file.ReadCharacter();
				if(szTemp.IsEmpty() || szTemp == " " || szTemp == "\t")
					continue;
				if(szTemp == "\n")
				{
					uiLine++;
					continue;
				}

				string szSection;
				dictionary dicTemp;

				if(szTemp == "[")
					bInSection = true;
				if(szTemp == "]")
					bInSection = false;
				if(szTemp == "{")
					bInContent = true;
				if(szTemp == "}")
				{
					bInContent = false;
					//用反射保存Section和Content
					//保存保存保存
					if(szKey.Find(".") != String::INVALID_INDEX )
					{
						array<string> aryTemp = szKey.Split(".");
						if(aryTemp[0].Find("-") != String::INVALID_INDEX )
						{
							array<string> aryTemp2 = aryTemp[0].Split("-");
							CBaseGear@ pGear = GearBank::GetGear(aryTemp2[1], aryTemp[1]).Copy();
							pGear.dicCustomVal = dicTemp;
							if(pData.Slot.exists(aryTemp2[0]))
								pData.Slot.set(aryTemp2[0], pGear);
						}
						else
						{
							CBaseGear@ pGear = GearBank::GetGear(aryTemp[0], aryTemp[1]).Copy();
							pGear.dicCustomVal = dicTemp;
							aryTempPlayerInventory.insertLast(@pGear);
						}
					}
					else
						ReadExcetipon(string(uiLine), string(file.Tell()), "小节标题格式错误，缺失分隔符\".\"");
				}
				if(bInSection)
					szSection += szTemp;
				if(bInContent)
				{
					string szKey;
					string szValue;
					bool IsInValue = false;
					if(szTemp == "=")
						IsInValue = true;
					if(szTemp == ";")
					{
						IsInValue == false;
						if(szKey.StartsWith("sz"))
							dicTemp.set(szKey, szValue);
						else if(szKey.StartsWith("i"))
							dicTemp.set(szKey, atoi(szValue));
						else if(szKey.StartsWith("fl"))
							dicTemp.set(szKey, atof(szValue));
						else if(szKey.StartsWith("b"))
							dicTemp.set(szKey, atobool(szValue));
						else if(szKey.StartsWith("vec"))
							dicTemp.set(szKey, GearUtility::atovec(szValue));
						else if(szKey.StartsWith("vec2"))
							dicTemp.set(szKey, GearUtility::atovec2(szValue));
						else if(szKey.StartsWith("aryi"))
							dicTemp.set(szKey, GearUtility::atoaryi(szValue));
						else if(szKey.StartsWith("arysz"))
							dicTemp.set(szKey, GearUtility::atoarysz(szValue));
					}
					if(IsInValue)
						szValue += szTemp;
					else
						szKey += szTemp;
				}
			}
			@pData.Inventory = @aryTempPlayerInventory;
			file.Close();
			return pData;
		}
		return null;
	}
	void Readfile() 
	{
		string szLine;
		string szContent;
		File@ file = g_FileSystem.OpenFile(dirGearFile, OpenFile::READ);
		if(file !is null && file.IsOpen()) 
		{
			while(!file.EOFReached()) 
			{
				file.ReadLine(szLine);

				if(szLine[0] == '/' && szLine[1] == '/')
					continue;
				
				szContent.opAddAssign(szLine);
			}
			file.Close();
		}
	}
}
