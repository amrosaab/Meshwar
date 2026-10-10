#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec2 uCenter;
uniform float uRadius;
uniform float uPhase;
uniform float uStrength;
uniform vec2 uSnapshotCenter;
uniform float uMapScale;
uniform float uMapRotation;
uniform sampler2D uMap;

out vec4 fragColor;

vec4 flowSample(float phase, float radius, float angle) {
  // A street feature travels from the rim toward the center and vanishes into
  // it. Inverse sampling pulls progressively farther-out map pixels inward.
  float sourceRadius = 1.0 - (1.0 - radius) * exp(-phase * 2.8);
  float twist = phase * 4.0 * pow(1.0 - radius, 0.8);
  float sourceAngle = angle + twist + uMapRotation;
  vec2 source = uSnapshotCenter + vec2(cos(sourceAngle), sin(sourceAngle))
      * sourceRadius * uRadius / uMapScale;
  vec2 uv = source / uSize;
  vec4 color = texture(uMap, clamp(uv, vec2(0.0), vec2(1.0)));
  float coverage = smoothstep(0.0, 0.025, uv.x) * smoothstep(0.0, 0.025, uv.y)
      * (1.0 - smoothstep(0.975, 1.0, uv.x))
      * (1.0 - smoothstep(0.975, 1.0, uv.y));
  return color * coverage;
}

void main() {
  vec2 delta = FlutterFragCoord().xy - uCenter;
  float radius = length(delta) / uRadius;
  if (radius >= 1.0) {
    fragColor = vec4(0.0);
    return;
  }

  float angle = atan(delta.y, delta.x);
  float secondPhase = fract(uPhase + 0.5);
  // Two staggered flows disappear before their phase resets. Their weights sum
  // to one, so the vortex continuously absorbs instead of reversing/breathing.
  float weight = pow(sin(uPhase * 3.14159265), 2.0);
  vec4 mapColor = flowSample(uPhase, radius, angle) * weight
      + flowSample(secondPhase, radius, angle) * (1.0 - weight);
  mapColor.rgb *= 1.0 - 0.88 * pow(1.0 - radius, 2.0);
  float alpha = (1.0 - smoothstep(0.86, 1.0, radius)) * uStrength;
  fragColor = mapColor * alpha;
}
