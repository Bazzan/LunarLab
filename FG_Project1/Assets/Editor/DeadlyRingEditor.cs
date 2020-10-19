using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(DeadlyRing))]
[CanEditMultipleObjects]
public class DeadlyRingEditor : Editor
{
    public override void OnInspectorGUI()
    {
        DeadlyRing ringObsticle = (DeadlyRing)target;

        EditorGUILayout.LabelField("Danger Zone", EditorStyles.boldLabel);
        GUILayout.Space(5);

        EditorGUILayout.BeginVertical("box");
        GUILayout.BeginHorizontal();
        ringObsticle.displayGizmos = EditorGUILayout.Toggle(ringObsticle.displayGizmos, GUILayout.Width(15));
        EditorGUILayout.LabelField("Display Gizmos");
        GUILayout.EndHorizontal();

        GUILayout.BeginHorizontal();
        ringObsticle.displayHandles = EditorGUILayout.Toggle(ringObsticle.displayHandles, GUILayout.Width(15));
        EditorGUILayout.LabelField("Display Paths/Sizes");
        GUILayout.EndHorizontal();

        GUILayout.Space(10);

        GUILayout.BeginHorizontal();
        if (GUILayout.Button("ADD", GUILayout.Width(50)))
        {
            if (ringObsticle.transform.childCount <= 6)
            {
                ringObsticle.AddPoints();
            }
            else
            {
                Debug.LogError("Can only have 6 connections!");
            }
        }

        if (GUILayout.Button("REMOVE", GUILayout.Width(70)))
        {
            if (ringObsticle.point.Count > 1)
            {
                ringObsticle.RemovePoints();
            }
        }
        GUILayout.EndHorizontal();

        for (int i = 0; i < ringObsticle.point.Count; i++)
        {
            GUILayout.BeginHorizontal();
            GUILayout.Label($"Connection {i + 1}", EditorStyles.boldLabel);
            GUILayout.FlexibleSpace();
            ringObsticle.point[i].lineColor = EditorGUILayout.ColorField(ringObsticle.point[i].lineColor, GUILayout.Width(50));
            GUILayout.EndHorizontal();

            GUILayout.BeginHorizontal();
            ringObsticle.point[i].min = EditorGUILayout.FloatField(ringObsticle.point[i].min, GUILayout.Width(55));
            GUILayout.Label("Min", GUILayout.Width(25));
            GUILayout.EndHorizontal();

            GUILayout.BeginHorizontal();
            ringObsticle.point[i].max = EditorGUILayout.FloatField(ringObsticle.point[i].max, GUILayout.Width(55));
            GUILayout.Label("Max", GUILayout.Width(27));
            GUILayout.EndHorizontal();


            GUILayout.BeginHorizontal();
            GUILayout.Label("Start Size", GUILayout.Width(60));
            ringObsticle.point[i].startSize = EditorGUILayout.Slider
                (ringObsticle.point[i].startSize, ringObsticle.point[i].min, ringObsticle.point[i].max);
            GUILayout.EndHorizontal();

            GUILayout.BeginHorizontal();
            GUILayout.Label("End Size", GUILayout.Width(60));
            ringObsticle.point[i].endSize = EditorGUILayout.Slider
                (ringObsticle.point[i].endSize, ringObsticle.point[i].min, ringObsticle.point[i].max);
            GUILayout.EndHorizontal();

            GUILayout.Space(10);

            GUILayout.BeginHorizontal();
            GUILayout.Label("Speed", GUILayout.Width(60));
            ringObsticle.point[i].speed = EditorGUILayout.Slider(ringObsticle.point[i].speed, 1, 10);
            GUILayout.EndHorizontal();

            GUILayout.Space(15);
        }

        EditorGUILayout.EndVertical();
        GUILayout.Space(10);

        EditorGUILayout.BeginVertical("box");
        EditorGUILayout.HelpBox("ONLY TOGGLE ON PLAYMODE TO TEST MOVEMENT OF CIRCLE", MessageType.Warning);
        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Spawn Dangerzone");
        ringObsticle.spawnDangerZone = EditorGUILayout.Toggle(ringObsticle.spawnDangerZone);
        EditorGUILayout.EndHorizontal();
        EditorGUILayout.EndVertical();
        //base.OnInspectorGUI();
    }

    private void OnSceneGUI()
    {
        DeadlyRing ringObsticle = (DeadlyRing)target;

        if (ringObsticle.transform.childCount >= 2)
        {
            if (ringObsticle.startEvent)
            {
                Handles.color = new Color(1, 0, 0, 0.1f);
                Handles.DrawSolidDisc(ringObsticle.circleRef.transform.position, ringObsticle.transform.forward, ringObsticle.circleRadius);
                Handles.color = new Color(1, 0, 0, 1f);
                Handles.DrawWireDisc(ringObsticle.circleRef.transform.position, ringObsticle.transform.forward, ringObsticle.circleRadius);
            }

            else if (!ringObsticle.startEvent)
            {
                Handles.color = new Color(0, 0, 1, 0.1f);
                Handles.DrawSolidDisc(ringObsticle.transform.GetChild(0).transform.position, ringObsticle.transform.forward, 1);
                Handles.color = new Color(0, 0, 1, 1f);
                Handles.DrawWireDisc(ringObsticle.transform.GetChild(0).transform.position, ringObsticle.transform.forward, 1);
            }

            if (ringObsticle.transform.childCount > 0 && ringObsticle.displayHandles)
            {
                for (int i = 0; i < ringObsticle.point.Count; i++)
                {
                    //Start Point
                    //Outline
                    Handles.color = new Color
                        (ringObsticle.point[i].lineColor.r, ringObsticle.point[i].lineColor.g, ringObsticle.point[i].lineColor.b, 1f);
                    Handles.DrawWireDisc(ringObsticle.point[i].startPointTransform.transform.position,
                            ringObsticle.transform.forward,
                            ringObsticle.point[i].startSize);
                    //Fill
                    Handles.color = new Color
                        (ringObsticle.point[i].lineColor.r, ringObsticle.point[i].lineColor.g, ringObsticle.point[i].lineColor.b, 0.1f);
                    Handles.DrawSolidDisc(ringObsticle.point[i].startPointTransform.transform.position,
                            ringObsticle.transform.forward,
                            ringObsticle.point[i].startSize);

                    //End Point
                    //Outline
                    Handles.color = new Color
                        (ringObsticle.point[i].lineColor.r, ringObsticle.point[i].lineColor.g, ringObsticle.point[i].lineColor.b, 1f);
                    Handles.DrawWireDisc(ringObsticle.point[i].endPointTransform.transform.position,
                            ringObsticle.transform.forward,
                            ringObsticle.point[i].endSize);
                    //Fill
                    Handles.color = new Color
                        (ringObsticle.point[i].lineColor.r, ringObsticle.point[i].lineColor.g, ringObsticle.point[i].lineColor.b, 0.1f);
                    Handles.DrawSolidDisc(ringObsticle.point[i].endPointTransform.transform.position,
                            ringObsticle.transform.forward,
                            ringObsticle.point[i].endSize);

                    //Line Between points
                    Handles.color = new Color
                        (ringObsticle.point[i].lineColor.r, ringObsticle.point[i].lineColor.g, ringObsticle.point[i].lineColor.b, 1f);
                    Handles.DrawLine(ringObsticle.point[i].startPointTransform.position, ringObsticle.point[i].endPointTransform.position);
                }
            }

            /* CUT FROM DEVELOPMENT (DELTA POINTS)

        for (int i = 0; i < ringObsticle.point.Count; i++)
        {
            #region Delta point stuff
            ringObsticle.point[i].startPointTransform = ringObsticle.transform.GetChild(i);
            for (int j = 0; j < ringObsticle.point[i].changeOnLine.Length; j++)
            {
                Vector2 deltaPointOnLine = Vector2.Lerp(ringObsticle.point[i].startPointTransform.position,
                ringObsticle.point[i].endPointTransform.position, ringObsticle.point[i].changeOnLine[j].pointOnLine);

                //Delta Points
                #region Point Ref

                //Outline of delta circle
                Handles.color = new Color
                    (ringObsticle.point[i].changeOnLine[j].pointColor.r,
                    ringObsticle.point[i].changeOnLine[j].pointColor.g,
                    ringObsticle.point[i].changeOnLine[j].pointColor.b, 1f);
                Handles.DrawWireDisc(deltaPointOnLine, ringObsticle.transform.forward, 1 * ringObsticle.point[i].changeOnLine[j].pointSize);

                //Filler of delta circle
                Handles.color = new Color
                    (ringObsticle.point[i].changeOnLine[j].pointColor.r * 1,
                    ringObsticle.point[i].changeOnLine[j].pointColor.g * 1,
                    ringObsticle.point[i].changeOnLine[j].pointColor.b * 1, 0.1f);
                Handles.DrawSolidDisc(deltaPointOnLine, ringObsticle.transform.forward, 1 * ringObsticle.point[i].changeOnLine[j].pointSize);

                //Point of delta circle
                Handles.color = new Color
                    (ringObsticle.point[i].changeOnLine[j].pointColor.r,
                    ringObsticle.point[i].changeOnLine[j].pointColor.g,
                    ringObsticle.point[i].changeOnLine[j].pointColor.b, 1f);
                Handles.DrawSolidDisc(deltaPointOnLine, ringObsticle.transform.forward, 0.1f);
                #endregion
        }
                #endregion
            */
        }

    }
}

