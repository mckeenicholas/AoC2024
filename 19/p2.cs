using System;
using System.Collections.Generic;
using System.IO;

string[] lines = File.ReadAllLines("input.txt");

List<string> available = [.. lines[0].Split(", ")];
List<string> patterns = [.. lines[2..]];

long total = 0;

foreach (var pattern in patterns)
{
    long[] possible = new long[pattern.Length + 1];
    possible[0] = 1;

    for (int i = 1; i <= pattern.Length; i++)
    {
        foreach (var item in available)
        {
            if (i >= item.Length && pattern.Substring(i - item.Length, item.Length) == item)
            {
                possible[i] += possible[i - item.Length];
            }
        }
    }

    total += possible[pattern.Length];
}

Console.WriteLine(total);
