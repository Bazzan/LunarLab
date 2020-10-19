using UnityEngine;

public class Goal : MonoBehaviour
{
    [SerializeField] private GameObject playnameInputField = default;
    [SerializeField] private Leaderboard leaderboard = default;
    
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (!other.CompareTag("Player")) return;
        playnameInputField.SetActive(true);
        leaderboard.SaveTime();
        Time.timeScale = 0.05f;
        Time.fixedDeltaTime = Time.timeScale * 0.02f;
    }
}
