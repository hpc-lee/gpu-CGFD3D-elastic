#ifndef SRC_FUNCS_H
#define SRC_FUNCS_H

#include <mpi.h>

#include "constants.h"
#include "gd_t.h"
#include "md_t.h"

/*************************************************
 * structure
 *************************************************/

typedef struct {
  int total_number;
  int max_nt; // max nt of stf and mrf per src
  int max_stage; // max number of rk stages
  int max_ext; // max extened points

  // for getting value in calculation
  int it;
  int istage;

  // for output
  char evtnm[CONST_MAX_STRLEN];

  // time independent
  int *si; // local i index 
  int *sj; // local j index 
  int *sk; // local k index 
  int *it_begin; // start t index
  int *it_end;   // end   t index
  int   *ext_num; // valid extend points for this src
  int   *ext_indx; // max_ext * total_number
  float *ext_coef;

  // force and/or moment
  int force_actived;
  int moment_actived;

  // time dependent
  // force stf
  float *Fx; // max_stage * max_nt * total_number;
  float *Fy;
  float *Fz;
  // moment rate
  float *Mxx; // max_stage *max_nt * total_number;
  float *Myy;
  float *Mzz;
  float *Mxz;
  float *Myz;
  float *Mxy;
} src_t;

/*************************************************
 * function prototype
 *************************************************/

int
src_coord_to_glob_indx(gd_t *gd,
                       float sx,
                       float sy,
                       float sz,
                       MPI_Comm comm,
                       int myid,
                       int   *ou_si, int *ou_sj, int *ou_sk,
                       float *ou_sx_inc, float *ou_sy_inc, float *ou_sz_inc,
                       float *wrk3d);

int
src_glob_ext_ishere(int si, int sj, int sk, int half_ext, gd_t *gd);

int
src_glob_ishere(int si, int sj, int sk, int half_ext, gd_t *gd);

int
src_coord_to_local_indx(gd_t *gd,
                        float sx, float sy, float sz,
                        int *si, int *sj, int *sk,
                        float *sx_inc, float *sy_inc, float *sz_inc,
                        float *wrk3d);


int
src_read_locate_file(gd_t *gd,
                     md_t *md,
                     src_t    *src,
                     char *in_src_file,
                     float t0,
                     float dt,
                     int   max_stages,
                     float *rk_stage_time,
                     int   npoint_half_ext,
                     MPI_Comm comm,
                     int myid);


float 
fun_ricker(float t, float fc, float t0);

float 
fun_ricker_deriv(float t, float fc, float t0);

float
fun_gauss(float t, float a, float t0);

float
fun_gauss_deriv(float t, float a, float t0);

float
fun_klauder(float t, float t0, float f1, float f2, float T);

float
src_cal_wavelet(float t, char *wavelet_name, float *wavelet_coefs);

void 
angle2moment(float strike, float dip, float rake, float* source_moment_tensor);

int
src_coord2index(float sx, float sy, float sz,
                int nx, int ny, int nz,
                int ni1, int ni2, int nj1, int nj2, int nk1, int nk2,
                float *x3d,
                float *y3d,
                float *z3d,
                float *wrk3d,
                int *si, int *sj, int *sk,
                float *sx_inc, float *sy_inc, float *sz_inc);

int
src_cart2curv_rdinterp(float sx, float sy, float sz, 
                       int num_points,
                       float *points_x, // x coord of all points
                       float *points_y,
                       float *points_z,
                       float *points_i, // curv coord of all points
                       float *points_j,
                       float *points_k,
                       float *si_curv, // interped curv coord
                       float *sj_curv,
                       float *sk_curv);

int
src_cart2curv_sample(float sx, float sy, float sz, 
                     int num_points,
                     float *points_x, // x coord of all points
                     float *points_y,
                     float *points_z,
                     float *points_i, // curv coord of all points
                     float *points_j,
                     float *points_k,
                     int    nx_sample,
                     int    ny_sample,
                     int    nz_sample,
                     float *si_curv, // interped curv coord
                     float *sj_curv,
                     float *sk_curv);

int
src_set_time(src_t *src, int it, int istage);

void
src_cal_norm_delt3d(float *delt, float x0, float y0, float z0,
                    float rx0, float ry0, float rz0, int LenDelt);

__global__ void
src_coords_to_glob_indx(float *all_coords_d, int *all_index_d, float *all_inc_d,
                        gd_t gd_d, int in_num_source, MPI_Comm comm, int myid);

__global__ void
src_depth_to_axis(float *all_coords_d, gd_t gd_d, 
                  int in_num_source, MPI_Comm comm, int myid);

int
src_muDA_to_moment(float strike, float dip, float rake, float mu, float D, float A,
             float *mxx, float *myy, float *mzz, float *myz, float *mxz, float *mxy);

int
src_print(src_t *src);

float
Blackman_window(float t, float dt,float t0);

#endif
