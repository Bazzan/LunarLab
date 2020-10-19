using System;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System.Collections.Generic;

public class MainMenuController : MonoBehaviour
{
    [Header("Arrays")]
    [SerializeField] GameObject screen;
    [SerializeField] GameObject[] menus; //0= Main Menu | 1= Options | 2= Credits
    [SerializeField] Transform[] movePoints;
    
    [Header("Variabels")]
    [SerializeField] Transform cameraObject;
    [SerializeField] PlayerSettings settings;
    [SerializeField] Dropdown resolutionMenu;
    public Image fade;
    float testFloat = 70;
    float screenBootTime = 10;
    float deltaSpeed;
    Resolution[] resolutions;

    bool startGame = false;
    int currentScreen = default;
    AudioSource uiClick;


    private void Awake()
    {
        Time.timeScale = 1f;
        Time.fixedDeltaTime = Time.timeScale * 0.02f;
        
        uiClick = GetComponent<AudioSource>();

        resolutions = Screen.resolutions;
        resolutionMenu.ClearOptions();

        int currentResolution = 0;
        List<string> resolutionOptions = new List<string>();
        for (int i = 0; i < resolutions.Length; i++)
        {
            string newResolution = $"{resolutions[i].width} x {resolutions[i].height}";
            resolutionOptions.Add(newResolution);

            if (resolutions[i].width == Screen.currentResolution.width && resolutions[i].height == Screen.currentResolution.height)
            {
                currentResolution = i;
            }
        }

        resolutionMenu.AddOptions(resolutionOptions);
        resolutionMenu.RefreshShownValue();
        resolutionMenu.value = currentResolution;

        settings.SetResolution(currentResolution, resolutions);
    }

    public void MainMenuScreen()
    {
        menus[0].SetActive(true);
        menus[1].SetActive(false);
        menus[2].SetActive(false);
        currentScreen = 0;
        uiClick.Play();
        deltaSpeed = 0;
    }

    public void OptionsScreen()
    {
        menus[0].SetActive(false);
        menus[1].SetActive(true);
        menus[2].SetActive(false);
        currentScreen = 1;
        uiClick.Play();
        deltaSpeed = 0;
    }

    public void Credits()
    {
        menus[0].SetActive(false);
        menus[1].SetActive(false);
        menus[2].SetActive(true);
        currentScreen = 2;
        uiClick.Play();
        deltaSpeed = 0;
    }

    public void StartGame()
    {
        startGame = true;
        Invoke("StartGameScene", 2f);
    }

    void StartGameScene()
    {
        SceneManager.LoadScene("LevelTest");
    }

    public void QuitButton()
    {
        Application.Quit();
    }

    private void Update()
    {
        if (startGame && Vector3.Distance(cameraObject.transform.position, movePoints[1].position) > 0)
        {
            deltaSpeed += (testFloat * Time.deltaTime);
            cameraObject.transform.position = Vector3.Lerp(movePoints[0].position, movePoints[1].position, deltaSpeed * 0.01f);
            cameraObject.transform.rotation = Quaternion.Lerp(movePoints[0].rotation, movePoints[1].rotation, deltaSpeed * 0.01f);


            fade.color = new Color(0, 0, 0, deltaSpeed * 0.01f);
        }

        if (deltaSpeed < 1)
        {
            deltaSpeed += screenBootTime * Time.deltaTime;
            screen.transform.localScale = Vector3.Lerp(Vector3.right, Vector3.one, deltaSpeed);
        }
    }
}
