using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class LightFlicker : MonoBehaviour
{
private Light lightSelf;
[SerializeField] private float startIntensity;
[SerializeField] private float endIntensity;
[SerializeField] private float duration;
    void Start()
    {
        lightSelf = gameObject.GetComponent<Light>();
        FlickLight();
    }
    private void FlickLight()
    {
         DOTween.To(() => lightSelf.intensity, startIntensity => lightSelf.intensity = startIntensity, endIntensity, duration)
            .SetEase(Ease.InOutSine)
            .SetLoops(-1, LoopType.Yoyo);
    }
}
