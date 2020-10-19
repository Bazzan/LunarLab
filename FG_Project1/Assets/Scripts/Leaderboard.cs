using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Leaderboard : MonoBehaviour
{
    [SerializeField] private List<highscoreItem> highscores = new List<highscoreItem>();

    private float timer = 0f;
    private bool timerActive = true;

    [SerializeField] private TextMeshProUGUI timerText = default;
    [SerializeField] private GameObject inputField = default;

    private bool isSaved = false;
    private void Start()
    {
        GetHighscores();
    }

    private void Update()
    {
        if (!timerActive) return;
        timer += Time.deltaTime;
        timerText.text = FormatTime(timer);
    }
    
    public void SaveTime()
    {
        timerActive = false;
    }
    
    private void GetHighscores()
    {
        for (int i = 0; i < PlayerPrefs.GetInt("listLength"); i++)
        {
            highscores.Add(new highscoreItem(
                PlayerPrefs.GetString("highscore" + i) , 
                PlayerPrefs.GetFloat("time" + i)));
        }
    }
    
    public void SetHighscore()
    {
        highscoreItem item = new highscoreItem(
            inputField.GetComponent<TMP_InputField>().text,
            timer);
        highscores.Add(item);

        highscores.Sort(delegate(highscoreItem x, highscoreItem y)
        {
            if (x.time == null && y.time == null) return 0;
            else if (x.time == null) return -1;
            else if (y.time == null) return 1;
            else return x.time.CompareTo(y.time);
        });

        PlayerPrefs.SetInt("recentIndex", highscores.IndexOf(item));
        
        isSaved = false;
    }

    public void ClearHighscores()
    {
        highscores.Clear();
        for (int i = 0; i < PlayerPrefs.GetInt("listLength"); i++)
        {
            PlayerPrefs.DeleteKey("highscore" + i);
        }
        PlayerPrefs.DeleteKey("listLength");
    }
    
    public void SaveHighscores()
    {
        if (isSaved) return;
        isSaved = true;
        for (int i = 0; i < highscores.Count; i++)
        {
            PlayerPrefs.SetString("highscore" + i, highscores[i].name);
            PlayerPrefs.SetFloat("time" + i, highscores[i].time);
        }
        PlayerPrefs.SetInt("listLength", highscores.Count);
        PlayerPrefs.Save();
    }

    public void ShowHighscores()
    {
        SceneManager.LoadScene(0);
    }
    
    public string FormatTime( float time )
    {
        int minutes = (int) time / 60 ;
        int seconds = (int) time - 60 * minutes;
        int milliseconds = (int) (1000 * (time - minutes * 60 - seconds));
        return string.Format("{0:00}:{1:00}:{2:000}", minutes, seconds, milliseconds );
    }
    
    private void OnDestroy() => SaveHighscores();
    private void OnApplicationQuit() => SaveHighscores();

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
