/** 
 * SP-400 bottle thread data. Available from https://isbt.com
 *
 * BOSL2 provides a great SP-400 implementation but I wanted to reference
 * some of the dimensions from the spec. Rather than try to rely on hidden
 * BOSL implementation details I stuck the data in a matrix so I can
 * reference it on my own.
 *
 * All dimensions are in mm. Columns are:
 * 1) Nominal bottle OD
 * 2) Actual bottle OD
 * 3) Bottle neck ID
 * 4) Bottle neck height
 * 5) Space between top of neck and uppermost thread edge
 * 6) Thread pitch
 * 7) Bottle neck OD
 * 8) Thread base profile width
 * 9) Thread profile height
 * 10) Thread top profile width
 */
// D,T,I,H,S,P,E,a,b,c
SP400 = [
    [18,17.68,8.26,9.42,0.94,3.18,15.54,2.13,1.07,0.91],
    [20,19.69,10.26,9.42,0.94,3.18,17.55,2.13,1.07,0.91],
    [22,21.69,12.27,9.42,0.94,3.18,19.56,2.13,1.07,0.91],
    [24,23.67,13.11,10.16,1.17,3.18,21.54,2.13,1.07,0.91],
    [28,27.38,15.60,10.16,1.17,4.24,24.99,2.39,1.19,1.02],
    [30,28.37,16.59,10.24,1.17,4.24,25.98,2.39,1.19,1.02],
    [33,31.83,20.09,10.24,1.17,4.24,29.44,2.39,1.19,1.02],
    [35,34.34,22.23,10.24,1.17,4.24,31.95,2.39,1.19,1.02],
    [38,37.19,25.07,10.24,1.17,4.24,34.8,2.39,1.19,1.02],
    [40,39.75,27.71,10.24,1.17,4.24,37.36,2.39,1.19,1.02],
    [43,41.63,29.59,10.24,1.17,4.24,39.24,2.39,1.19,1.02],
    [45,43.82,31.78,10.24,1.17,4.24,41.43,2.39,1.19,1.02],
    [48,47.12,35.08,10.24,1.17,4.24,44.73,2.39,1.19,1.02],
    [51,49.56,37.57,10.36,1.17,4.24,47.17,2.39,1.19,1.02],
    [53,52.07,40.08,10.36,1.17,4.24,49.68,2.39,1.19,1.02],
    [58,56.06,44.07,10.36,1.17,4.24,53.67,2.39,1.19,1.02],
    [60,59.06,47.07,10.36,1.17,4.24,56.67,2.39,1.19,1.02],
    [63,62.08,50.09,10.36,1.17,4.24,59.69,2.39,1.19,1.02],
    [66,65.07,53.09,10.36,1.17,4.24,62.69,2.39,1.19,1.02],
    [70,69.06,57.07,10.36,1.17,4.24,66.68,2.39,1.19,1.02],
    [75,73.56,61.57,10.36,1.17,4.24,71.17,2.39,1.19,1.02],
    [77,76.66,64.67,12.37,1.52,4.24,74.27,2.39,1.19,1.02],
    [83,82.58,69.93,12.37,1.52,5.08,79.53,3.05,1.52,1.30],
    [89,88.75,74.12,13.59,1.52,5.08,85.7,3.05,1.52,1.30],
    [100,99.57,84.94,15.16,1.52,5.08,96.52,3.05,1.52,1.30],
    [110,109.58,94.92,15.16,1.52,5.08,106.53,3.05,1.52,1.30],
    [120,119.56,104.93,17.40,1.52,5.08,116.51,3.05,1.52,1.30]
];

function sp400_row(nom_od) =
  let(i = search(nom_od, [for (r=SP400) r[0]])[0])
  assert(i != undef, str("Unknown SP-400 nominal OD: ", nom_od))
  SP400[i];

function sp400_row_for_thread_od(target_od) =
  let( matches = [ for (r = SP400) if (r[1] >= target_od) r ])
  assert(
    len(matches) > 0,
    str("Requested thread OD ", target_od, " exceeds maximum actual OD ", SP400[len(SP400) - 1][1])
  )
  matches[0];

function sp400_max_neck_id(neck_wall) =
  let (max_od = SP400[len(SP400) - 1][6])
  max_od - 2 * neck_wall;

function sp400_row_for_neck_id(neck_id, neck_wall) =
  let (neck_od = neck_id + 2 * neck_wall)
  let( matches = [ for (r = SP400) if (r[6] >= neck_od) r ])
  assert(
    len(matches) > 0,
    str("Requested neck OD ", neck_od, " exceeds maximum actual OD ", SP400[len(SP400) - 1][6])
  )
  matches[0];