using UnityEngine;
using UnityEngine.Audio;

public class PlayerSettings : MonoBehaviour
{
    public AudioMixer audioMixer;

    [Header("Player Settings")]
    public float masterVolume, musicVolume, soundeffectVolume;
    public int qualityIndex = 5;
    public int selectedResolution;
    public bool fullScreen;

    private void Awake()
    {
        DontDestroyOnLoad(this.gameObject);
    }

    public void MainVolume(float volume)
    {
        masterVolume = volume;
        audioMixer.SetFloat("Master", volume);
    }

    public void MusicVolume(float volume)
    {
        musicVolume = volume;
        audioMixer.SetFloat("Music", volume);
    }

    public void SoundeffectsVolume(float volume)
    {
        soundeffectVolume = volume;
        audioMixer.SetFloat("Soundeffects", volume);
    }

    public void SetQuality(int qualityLevel)
    {
        qualityIndex = qualityLevel;
        QualitySettings.SetQualityLevel(qualityLevel);
    }

    public void SetResolution(int resolution, Resolution[] resolutions) 
    {
        selectedResolution = resolution;
        Resolution currentResolution = resolutions[resolution];
        Screen.SetResolution(currentResolution.width, currentResolution.height, Screen.fullScreen);
    }

    public void Fullscreen(bool isFullscreen)
    {
        fullScreen = isFullscreen;
        Screen.fullScreen = isFullscreen;
    }

}
