using System;
using System.Collections.Generic;
using System.IO;

string[] lines = File.ReadAllLines("input.txt");

List<string> available = [.. lines[0].Split(", ")];
List<string> patterns = [.. lines[2..]];

int total = 0;

foreach (var pattern in patterns)
{
    bool[] possible = new bool[pattern.Length + 1];
    possible[0] = true;

    for (int i = 1; i <= pattern.Length; i++)
    {
        foreach (var item in available)
        {
            if (i >= item.Length && pattern.Substring(i - item.Length, item.Length) == item)
            {
                if (possible[i - item.Length])
                {
                    possible[i] = true;
                    break;
                }
            }
        }
    }

    if (possible[pattern.Length])
    {
        total++;
    }
}

Console.WriteLine(total);
