using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using TMPro;

public class ShowTextTutorial : MonoBehaviour
{
    public GameObject player;
    public TMP_Text TextObject;
    [TextArea]
    public string Message = "";
    [TextArea]
    public string GamepadMessage = "";
    public float ShowForSeconds = 4;
    public bool WaitBeforeShowing = false;
    public float BeforeSeconds = 0;
    private PlayerInput playerInput;
    
    void Start() {
        playerInput = player.GetComponent<PlayerInput>();
        playerInput.controlsChangedEvent.AddListener(OnControlsChanged);
    }

    void OnTriggerEnter(Collider c) {
        if (c.gameObject.tag == "Player")
            StartCoroutine(StartText());
    }

    IEnumerator StartText() {
        if (WaitBeforeShowing) 
            yield return new WaitForSeconds(BeforeSeconds);
        UpdateText();
        yield return new WaitForSeconds(ShowForSeconds);
        HideText();
        Destroy(gameObject);
	}

    private void UpdateText() {
        if (playerInput.currentControlScheme == "KeyboardMouse") {
            TextObject.text = Message;
        } else if (playerInput.currentControlScheme == "Gamepad") {
            TextObject.text = GamepadMessage;
        }
    }

    private void HideText() {
        if (IsThisMessageTheCurrentMessage())
            TextObject.text = "";
    }

    public void OnControlsChanged(PlayerInput input) {
        if (IsThisMessageTheCurrentMessage()) {
            UpdateText();
        }
    }

    private bool IsThisMessageTheCurrentMessage() {
        return TextObject.text == Message || TextObject.text == GamepadMessage;
    }
}
