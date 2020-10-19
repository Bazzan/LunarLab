using UnityEngine.InputSystem;
using UnityEngine;
using UnityEngine.Events;

public class PlayerInput : MonoBehaviour
{
    public float MoveInput { get; private set; }
    public float Thrust { get; private set; }
    
    public Vector2 MoveAltInput { get; private set; }

    [SerializeField] private UnityEvent[] resetEvents = default;

    private void OnMove(InputValue value) => MoveInput = value.Get<float>();
    private void OnThrust(InputValue value) => Thrust = value.Get<float>();
    
    private void OnMoveAlt(InputValue value) => MoveAltInput = value.Get<Vector2>();

    private void OnReset0() => resetEvents[0].Invoke();
    private void OnReset1() => resetEvents[1].Invoke();
    private void OnReset2() => resetEvents[2].Invoke();
    private void OnReset3() => resetEvents[3].Invoke();
    private void OnReset4() => resetEvents[4].Invoke();
    private void OnReset5() => resetEvents[5].Invoke();
    private void OnReset6() => resetEvents[6].Invoke();
    private void OnReset7() => resetEvents[7].Invoke();
    private void OnReset8() => resetEvents[8].Invoke();
    private void OnReset9() => resetEvents[9].Invoke();
}