using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class DisplayLeaderboard : MonoBehaviour
{
    [SerializeField] private List<highscoreItem> highscores = new List<highscoreItem>();
    [SerializeField] private TextMeshProUGUI[] names = new TextMeshProUGUI[11];
    [SerializeField] private TextMeshProUGUI[] times = new TextMeshProUGUI[11];
    [SerializeField] private TextMeshProUGUI placement = default;

    private void Start()
    {
        GetHighscores();
        DisplayHighscores();
    }

    private void GetHighscores()
    {
        for (int i = 0; i < PlayerPrefs.GetInt("listLength"); i++)
        {
            highscores.Add(new highscoreItem(
                PlayerPrefs.GetString("highscore" + i) , 
                PlayerPrefs.GetFloat("time" + i)));
        }
        placement.text = (PlayerPrefs.GetInt("recentIndex") + 1).ToString();
    }

    private void DisplayHighscores()
    {
        for (int i = 0; i < (PlayerPrefs.GetInt("listLength") < 10 ? PlayerPrefs.GetInt("listLength"): 10); i++)
        {
            names[i].text = highscores[i].name;
            float time = highscores[i].time;
            times[i].text = FormatTime(time);
        }
        if (!PlayerPrefs.HasKey("recentIndex")) return;
        int recentIndex = PlayerPrefs.GetInt("recentIndex");
        names[10].text = highscores[recentIndex].name;
        times[10].text = FormatTime(highscores[recentIndex].time);
    }
    
    public string FormatTime( float time )
    {
        int minutes = (int) time / 60 ;
        int seconds = (int) time - 60 * minutes;
        int milliseconds = (int) (1000 * (time - minutes * 60 - seconds));
        return string.Format("{0:00}:{1:00}:{2:000}", minutes, seconds, milliseconds );
    }
    
    private class highscoreItem
    {
        public string name;
        public float time;

        public highscoreItem (string name, float time)
        {
            this.name = name;
            this.time = time;
        }
    }
}
