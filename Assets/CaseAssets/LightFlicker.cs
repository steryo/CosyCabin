using UnityEngine;
using DG.Tweening;

public class LightFlicker : MonoBehaviour
{
    private Light lightSelf;
    [SerializeField] private float startIntensity;
    [SerializeField] private float endIntensity;
    [SerializeField] private float lightDuration;
    [SerializeField] private bool moveEnabled;
    [SerializeField] private float moveAmount;
    [SerializeField] private float moveDuration;

    void Start()
    {
        lightSelf = gameObject.GetComponent<Light>();

        Sequence parallelSequence = DOTween.Sequence();
        Tween flickerTween = FlickLight();
        parallelSequence.Append(flickerTween);
        if (moveEnabled)
        {
            Tween moveTween = MoveLoop();
            parallelSequence.Insert(0, moveTween);
        }
        parallelSequence.SetLoops(-1, LoopType.Yoyo);
        parallelSequence.Play();
    }

    private Tween FlickLight()
    {
        return DOTween.To(() => lightSelf.intensity, startIntensity => lightSelf.intensity = startIntensity, endIntensity, lightDuration)
            .SetEase(Ease.InOutSine);
    }

    private Tween MoveLoop()
    {
        return transform.DOMoveZ(transform.position.z + moveAmount, moveDuration)
            .SetEase(Ease.InOutSine);
    }
}