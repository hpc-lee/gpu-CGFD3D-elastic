#ifndef SV_CURV_COL_EL_ANISO_H
#define SV_CURV_COL_EL_ANISO_H

#include "fd_t.h"
#include "mympi_t.h"
#include "gd_t.h"
#include "md_t.h"
#include "wav_t.h"
#include "src_t.h"
#include "bdry_t.h"
#include "io_funcs.h"
#include <cuda_runtime.h>

/*************************************************
 * function prototype
 *************************************************/

void
sv_curv_col_el_aniso_onestage(
  float *w_cur_d,
  float *rhs_d, 
  wav_t  wav_d,
  fd_wav_t fd_wav_d,
  gd_t  gd_d,
  gd_metric_t metric_d,
  md_t md_d,
  bdrypml_t  bdrypml_d,
  bdryfree_t bdryfree_d,
  src_t src_d,
  // include different order/stentil
  int num_of_fdx_op, fd_op_t *fdx_op,
  int num_of_fdy_op, fd_op_t *fdy_op,
  int num_of_fdz_op, fd_op_t *fdz_op,
  int fdz_max_len, 
  const int myid);

__global__ void
sv_curv_col_el_aniso_rhs_inner_gpu(
    float *  Vx , float *  Vy , float *  Vz ,
    float *  Txx, float *  Tyy, float *  Tzz,
    float *  Txz, float *  Tyz, float *  Txy,
    float * hVx , float * hVy , float * hVz ,
    float * hTxx, float * hTyy, float * hTzz,
    float * hTxz, float * hTyz, float * hTxy,
    float * xi_x, float * xi_y, float * xi_z,
    float * et_x, float * et_y, float * et_z,
    float * zt_x, float * zt_y, float * zt_z,
    float * c11d, float * c12d, float * c13d,
    float * c14d, float * c15d, float * c16d,
                  float * c22d, float * c23d,
    float * c24d, float * c25d, float * c26d,
                                float * c33d,
    float * c34d, float * c35d, float * c36d,
    float * c44d, float * c45d, float * c46d,
                  float * c55d, float * c56d,
                                float * c66d,
                                float * slw3d,
    int ni1, int ni, int nj1, int nj, int nk1, int nk,
    size_t siz_iy, size_t siz_iz,
    size_t * lfdx_shift, float * lfdx_coef,
    size_t * lfdy_shift, float * lfdy_coef,
    size_t * lfdz_shift, float * lfdz_coef,
    const int myid);

__global__ void
sv_curv_col_el_aniso_rhs_vlow_z2_gpu(
    float *  Vx , float *  Vy , float *  Vz ,
    float * hTxx, float * hTyy, float * hTzz,
    float * hTxz, float * hTyz, float * hTxy,
    float * xi_x, float * xi_y, float * xi_z,
    float * et_x, float * et_y, float * et_z,
    float * zt_x, float * zt_y, float * zt_z,
    float * c11d, float * c12d, float * c13d,
    float * c14d, float * c15d, float * c16d,
                  float * c22d, float * c23d,
    float * c24d, float * c25d, float * c26d,
                                float * c33d,
    float * c34d, float * c35d, float * c36d,
    float * c44d, float * c45d, float * c46d,
                  float * c55d, float * c56d,
                                float * c66d,
                                float * slw3d,
    float * matVx2Vz, float * matVy2Vz,
    int ni1, int ni, int nj1, int nj, int nk1, int nk2,
    size_t siz_iy, size_t siz_iz,
    int fdx_len, size_t * lfdx_shift, float * lfdx_coef,
    int fdy_len, size_t * lfdy_shift, float * lfdy_coef,
    int num_of_fdz_op, int fdz_max_len, int * fdz_len,
    float *lfdz_coef_all, size_t *lfdz_shift_all,
    const int myid);

int
sv_curv_col_el_aniso_rhs_cfspml(
    float *  Vx , float *  Vy , float *  Vz ,
    float *  Txx, float *  Tyy, float *  Tzz,
    float *  Txz, float *  Tyz, float *  Txy,
    float * hVx , float * hVy , float * hVz ,
    float * hTxx, float * hTyy, float * hTzz,
    float * hTxz, float * hTyz, float * hTxy,
    float * xi_x, float * xi_y, float * xi_z,
    float * et_x, float * et_y, float * et_z,
    float * zt_x, float * zt_y, float * zt_z,
    float * c11d, float * c12d, float * c13d,
    float * c14d, float * c15d, float * c16d,
                  float * c22d, float * c23d,
    float * c24d, float * c25d, float * c26d,
                                float * c33d,
    float * c34d, float * c35d, float * c36d,
    float * c44d, float * c45d, float * c46d,
                  float * c55d, float * c56d,
                                float * c66d,
                                float * slw3d,
    int nk2, size_t siz_iy, size_t siz_iz,
    size_t * lfdx_shift, float * lfdx_coef,
    size_t * lfdy_shift, float * lfdy_coef,
    size_t * lfdz_shift, float * lfdz_coef,
    bdrypml_t bdrypml_d, bdryfree_t bdryfree_d,
    const int myid);

__global__ void
sv_curv_col_el_aniso_rhs_cfspml_gpu(
    int idim, int iside,
    float *  Vx , float *  Vy , float *  Vz ,
    float *  Txx, float *  Tyy, float *  Tzz,
    float *  Txz, float *  Tyz, float *  Txy,
    float * hVx , float * hVy , float * hVz ,
    float * hTxx, float * hTyy, float * hTzz,
    float * hTxz, float * hTyz, float * hTxy,
    float * xi_x, float * xi_y, float * xi_z,
    float * et_x, float * et_y, float * et_z,
    float * zt_x, float * zt_y, float * zt_z,
    float * c11d, float * c12d, float * c13d,
    float * c14d, float * c15d, float * c16d,
                  float * c22d, float * c23d,
    float * c24d, float * c25d, float * c26d,
                                float * c33d,
    float * c34d, float * c35d, float * c36d,
    float * c44d, float * c45d, float * c46d,
                  float * c55d, float * c56d,
                                float * c66d,
                                float * slw3d,
    int nk2, size_t siz_iy, size_t siz_iz,
    size_t * lfdx_shift, float * lfdx_coef,
    size_t * lfdy_shift, float * lfdy_coef,
    size_t * lfdz_shift, float * lfdz_coef,
    bdrypml_t bdrypml_d, bdryfree_t bdryfree_d,
    const int myid);

int
sv_curv_col_el_aniso_dvh2dvz(gd_t        *gd,
                             gd_metric_t *metric,
                             md_t        *md,
                             bdryfree_t  *bdryfree);

#endif
