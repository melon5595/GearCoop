namespace GearFileIO
{
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
