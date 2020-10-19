using UnityEditor;
using UnityEngine;
    
[CustomEditor(typeof(Leaderboard))]
public class LeaderboardEditor : Editor
{
    public override void OnInspectorGUI() {
        Leaderboard leaderboard = (Leaderboard) target;
        
        DrawDefaultInspector();
        if (GUILayout.Button("Clear Highscores"))
            leaderboard.ClearHighscores();
        
        if (GUILayout.Button("Save Time"))
            leaderboard.SaveTime();
    }
}
