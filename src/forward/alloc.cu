#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda_runtime.h>
#include "alloc.h"
#include "cuda_common.h"

// only copy grid info
int init_gdinfo_device(gd_t *gd, gd_t *gd_d)
{
  memcpy(gd_d,gd,sizeof(gd_t));

  return 0;
}

int init_gd_device(gd_t *gd, gd_t *gd_d)
{
  int nx = gd->nx;
  int ny = gd->ny;
  int nz = gd->nz;
  size_t siz_icmp = gd->siz_icmp;
  memcpy(gd_d,gd,sizeof(gd_t));
  gd_d->x3d = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  gd_d->y3d = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  gd_d->z3d = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  gd_d->x1d = (float *) cuda_malloc(sizeof(float)*nx);
  gd_d->y1d = (float *) cuda_malloc(sizeof(float)*ny);
  gd_d->z1d = (float *) cuda_malloc(sizeof(float)*nz);

  gd_d->cell_xmin = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  gd_d->cell_xmax = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  gd_d->cell_ymin = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  gd_d->cell_ymax = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  gd_d->cell_zmin = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  gd_d->cell_zmax = (float *) cuda_malloc(sizeof(float)*siz_icmp);

  gd_d->tile_istart = (int *) cuda_malloc(sizeof(int)*GD_TILE_NX);
  gd_d->tile_iend   = (int *) cuda_malloc(sizeof(int)*GD_TILE_NX);
  gd_d->tile_jstart = (int *) cuda_malloc(sizeof(int)*GD_TILE_NY);
  gd_d->tile_jend   = (int *) cuda_malloc(sizeof(int)*GD_TILE_NY);
  gd_d->tile_kstart = (int *) cuda_malloc(sizeof(int)*GD_TILE_NZ);
  gd_d->tile_kend   = (int *) cuda_malloc(sizeof(int)*GD_TILE_NZ);

  int size = GD_TILE_NX * GD_TILE_NY * GD_TILE_NZ;
  gd_d->tile_xmin = (float *) cuda_malloc(sizeof(float)*size);
  gd_d->tile_xmax = (float *) cuda_malloc(sizeof(float)*size);
  gd_d->tile_ymin = (float *) cuda_malloc(sizeof(float)*size);
  gd_d->tile_ymax = (float *) cuda_malloc(sizeof(float)*size);
  gd_d->tile_zmin = (float *) cuda_malloc(sizeof(float)*size);
  gd_d->tile_zmax = (float *) cuda_malloc(sizeof(float)*size);

  CUDACHECK(cudaMemcpy(gd_d->x3d, gd->x3d, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->y3d, gd->y3d, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->z3d, gd->z3d, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));

  CUDACHECK(cudaMemcpy(gd_d->cell_xmin, gd->cell_xmin, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->cell_xmax, gd->cell_xmax, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->cell_ymin, gd->cell_ymin, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->cell_ymax, gd->cell_ymax, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->cell_zmin, gd->cell_zmin, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->cell_zmax, gd->cell_zmax, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));

  CUDACHECK(cudaMemcpy(gd_d->tile_istart, gd->tile_istart, sizeof(int)*GD_TILE_NX, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->tile_iend,   gd->tile_iend, sizeof(int)*GD_TILE_NX, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->tile_jstart, gd->tile_jstart, sizeof(int)*GD_TILE_NY, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->tile_jend,   gd->tile_jend, sizeof(int)*GD_TILE_NY, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->tile_kstart, gd->tile_kstart, sizeof(int)*GD_TILE_NZ, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->tile_kend,   gd->tile_kend, sizeof(int)*GD_TILE_NZ, cudaMemcpyHostToDevice));

  CUDACHECK(cudaMemcpy(gd_d->tile_xmin, gd->tile_xmin, sizeof(float)*size, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->tile_xmax, gd->tile_xmax, sizeof(float)*size, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->tile_ymin, gd->tile_ymin, sizeof(float)*size, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->tile_ymax, gd->tile_ymax, sizeof(float)*size, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->tile_zmin, gd->tile_zmin, sizeof(float)*size, cudaMemcpyHostToDevice));
  CUDACHECK(cudaMemcpy(gd_d->tile_zmax, gd->tile_zmax, sizeof(float)*size, cudaMemcpyHostToDevice));

  return 0;
}

int init_md_device(md_t *md, md_t *md_d)
{
  size_t siz_icmp = md->siz_icmp;

  memcpy(md_d,md,sizeof(md_t));
  if (md->medium_type == CONST_MEDIUM_ACOUSTIC_ISO)
  {
    md_d->rho    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->kappa  = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    CUDACHECK(cudaMemcpy(md_d->rho,    md->rho,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->kappa,  md->kappa,  sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
  }
  if (md->medium_type == CONST_MEDIUM_ELASTIC_ISO)
  {
    md_d->rho    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->lambda = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->mu     = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    CUDACHECK(cudaMemcpy(md_d->rho,    md->rho,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->lambda, md->lambda, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->mu,     md->mu,     sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
  }
  if (md->medium_type == CONST_MEDIUM_VISCOELASTIC_ISO)
  {
    md_d->rho    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->lambda = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->mu     = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    CUDACHECK(cudaMemcpy(md_d->rho,    md->rho,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->lambda, md->lambda, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->mu,     md->mu,     sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    if (md->visco_type == CONST_VISCO_GRAVES_QS) {
      md_d->Qs = (float *) cuda_malloc(sizeof(float)*siz_icmp);
      CUDACHECK(cudaMemcpy(md_d->Qs, md->Qs, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    } else if(md->visco_type == CONST_VISCO_GMB) {
      md_d->Qp = (float *) cuda_malloc(sizeof(float)*siz_icmp);
      md_d->Qs = (float *) cuda_malloc(sizeof(float)*siz_icmp);
      CUDACHECK(cudaMemcpy(md_d->Qp, md->Qp, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
      CUDACHECK(cudaMemcpy(md_d->Qs, md->Qs, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
      for(int i=0; i<md->nmaxwell; i++)
      {
        md_d->Ylam[i] = (float *) cuda_malloc(sizeof(float)*siz_icmp);
        md_d->Ymu [i] = (float *) cuda_malloc(sizeof(float)*siz_icmp);
        CUDACHECK(cudaMemcpy(md_d->Ylam[i], md->Ylam[i], sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
        CUDACHECK(cudaMemcpy(md_d->Ymu [i], md->Ymu [i], sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
      }

        md_d->wl = (float *) cuda_malloc(sizeof(float)*md->nmaxwell);
        CUDACHECK(cudaMemcpy(md_d->wl, md->wl, sizeof(float)*md->nmaxwell, cudaMemcpyHostToDevice));
    }
  }
  if (md->medium_type == CONST_MEDIUM_ELASTIC_VTI)
  {
    md_d->rho    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c11    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c33    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c55    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c66    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c13    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    CUDACHECK(cudaMemcpy(md_d->rho,    md->rho,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c11,    md->c11,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c33,    md->c33,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c55,    md->c55,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c66,    md->c66,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c13,    md->c13,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
  }
  if (md->medium_type == CONST_MEDIUM_ELASTIC_ANISO)
  {
    md_d->rho    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c11    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c12    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c13    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c14    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c15    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c16    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c22    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c23    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c24    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c25    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c26    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c33    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c34    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c35    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c36    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c44    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c45    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c46    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c55    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c56    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    md_d->c66    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
    CUDACHECK(cudaMemcpy(md_d->rho,    md->rho,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c11,    md->c11,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c12,    md->c12,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c13,    md->c13,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c14,    md->c14,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c15,    md->c15,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c16,    md->c16,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c22,    md->c22,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c23,    md->c23,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c24,    md->c24,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c25,    md->c25,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c26,    md->c26,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c33,    md->c33,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c34,    md->c34,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c35,    md->c35,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c36,    md->c36,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c44,    md->c44,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c45,    md->c45,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c46,    md->c46,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c55,    md->c55,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c56,    md->c56,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(md_d->c66,    md->c66,    sizeof(float)*siz_icmp, cudaMemcpyHostToDevice));
  }

  return 0;
}

int init_fd_device(fd_t *fd, fd_wav_t *fd_wav_d, gd_t *gd)
{
  int max_len = fd->fdz_max_len; //=5 
  int max_lay = fd->num_of_fdz_op;
  fd_wav_d->fdz_len_d  = (int *) cuda_malloc(sizeof(int)*max_lay);
  fd_wav_d->fdx_coef_d = (float *) cuda_malloc(sizeof(float)*max_len);
  fd_wav_d->fdy_coef_d = (float *) cuda_malloc(sizeof(float)*max_len);
  fd_wav_d->fdz_coef_d = (float *) cuda_malloc(sizeof(float)*max_len);
  fd_wav_d->fdz_coef_all_d = (float *) cuda_malloc(sizeof(float)*max_len*max_lay);

  fd_wav_d->fdx_indx_d = (int *) cuda_malloc(sizeof(int)*max_len);
  fd_wav_d->fdy_indx_d = (int *) cuda_malloc(sizeof(int)*max_len);
  fd_wav_d->fdz_indx_d = (int *) cuda_malloc(sizeof(int)*max_len);
  fd_wav_d->fdz_indx_all_d  = (int *) cuda_malloc(sizeof(int)*max_len*max_lay);

  fd_wav_d->fdx_shift_d = (size_t *) cuda_malloc(sizeof(size_t)*max_len);
  fd_wav_d->fdy_shift_d = (size_t *) cuda_malloc(sizeof(size_t)*max_len);
  fd_wav_d->fdz_shift_d = (size_t *) cuda_malloc(sizeof(size_t)*max_len);
  fd_wav_d->fdz_shift_all_d = (size_t *) cuda_malloc(sizeof(size_t)*max_len*max_lay);

  return 0;
}

int init_metric_device(gd_metric_t *metric, gd_metric_t *metric_d)
{
  size_t siz_icmp = metric->siz_icmp;

  memcpy(metric_d,metric,sizeof(gd_metric_t));
  metric_d->jac     = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  metric_d->xi_x    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  metric_d->xi_y    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  metric_d->xi_z    = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  metric_d->eta_x   = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  metric_d->eta_y   = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  metric_d->eta_z   = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  metric_d->zeta_x   = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  metric_d->zeta_y   = (float *) cuda_malloc(sizeof(float)*siz_icmp);
  metric_d->zeta_z   = (float *) cuda_malloc(sizeof(float)*siz_icmp);

  CUDACHECK( cudaMemcpy(metric_d->jac,   metric->jac,   sizeof(float)*siz_icmp, cudaMemcpyHostToDevice) );
  CUDACHECK( cudaMemcpy(metric_d->xi_x,  metric->xi_x,  sizeof(float)*siz_icmp, cudaMemcpyHostToDevice) );
  CUDACHECK( cudaMemcpy(metric_d->xi_y,  metric->xi_y,  sizeof(float)*siz_icmp, cudaMemcpyHostToDevice) );
  CUDACHECK( cudaMemcpy(metric_d->xi_z,  metric->xi_z,  sizeof(float)*siz_icmp, cudaMemcpyHostToDevice) );
  CUDACHECK( cudaMemcpy(metric_d->eta_x, metric->eta_x, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice) );
  CUDACHECK( cudaMemcpy(metric_d->eta_y, metric->eta_y, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice) );
  CUDACHECK( cudaMemcpy(metric_d->eta_z, metric->eta_z, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice) );
  CUDACHECK( cudaMemcpy(metric_d->zeta_x, metric->zeta_x, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice) );
  CUDACHECK( cudaMemcpy(metric_d->zeta_y, metric->zeta_y, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice) );
  CUDACHECK( cudaMemcpy(metric_d->zeta_z, metric->zeta_z, sizeof(float)*siz_icmp, cudaMemcpyHostToDevice) );
  return 0;
}

int init_src_device(src_t *src, src_t *src_d)
{
  int total_number = src->total_number;
  int max_ext      = src->max_ext;
  size_t temp_all     = (src->total_number) * (src->max_nt) * (src->max_stage);

  memcpy(src_d,src,sizeof(src_t));
  if(src->force_actived == 1) {
    src_d->Fx  = (float *) cuda_malloc(sizeof(float)*temp_all);
    src_d->Fy  = (float *) cuda_malloc(sizeof(float)*temp_all);
    src_d->Fz  = (float *) cuda_malloc(sizeof(float)*temp_all);
    CUDACHECK( cudaMemcpy(src_d->Fx,  src->Fx,  sizeof(float)*temp_all, cudaMemcpyHostToDevice));
    CUDACHECK( cudaMemcpy(src_d->Fy,  src->Fy,  sizeof(float)*temp_all, cudaMemcpyHostToDevice));
    CUDACHECK( cudaMemcpy(src_d->Fz,  src->Fz,  sizeof(float)*temp_all, cudaMemcpyHostToDevice));
  }
  if(src->moment_actived == 1) {
    src_d->Mxx = (float *) cuda_malloc(sizeof(float)*temp_all);
    src_d->Myy = (float *) cuda_malloc(sizeof(float)*temp_all);
    src_d->Mzz = (float *) cuda_malloc(sizeof(float)*temp_all);
    src_d->Mxz = (float *) cuda_malloc(sizeof(float)*temp_all);
    src_d->Myz = (float *) cuda_malloc(sizeof(float)*temp_all);
    src_d->Mxy = (float *) cuda_malloc(sizeof(float)*temp_all);
    CUDACHECK( cudaMemcpy(src_d->Mxx, src->Mxx, sizeof(float)*temp_all, cudaMemcpyHostToDevice));
    CUDACHECK( cudaMemcpy(src_d->Myy, src->Myy, sizeof(float)*temp_all, cudaMemcpyHostToDevice));
    CUDACHECK( cudaMemcpy(src_d->Mzz, src->Mzz, sizeof(float)*temp_all, cudaMemcpyHostToDevice));
    CUDACHECK( cudaMemcpy(src_d->Mxz, src->Mxz, sizeof(float)*temp_all, cudaMemcpyHostToDevice));
    CUDACHECK( cudaMemcpy(src_d->Myz, src->Myz, sizeof(float)*temp_all, cudaMemcpyHostToDevice));
    CUDACHECK( cudaMemcpy(src_d->Mxy, src->Mxy, sizeof(float)*temp_all, cudaMemcpyHostToDevice));
  }
  if(total_number>0)
  {
    src_d->ext_num  = (int *) cuda_malloc(sizeof(int)*total_number);
    src_d->it_begin = (int *) cuda_malloc(sizeof(int)*total_number);
    src_d->it_end   = (int *) cuda_malloc(sizeof(int)*total_number);
    src_d->ext_indx = (int *) cuda_malloc(sizeof(int)*total_number*max_ext);
    src_d->ext_coef = (float *) cuda_malloc(sizeof(float)*total_number*max_ext);

    CUDACHECK( cudaMemcpy(src_d->ext_num,  src->ext_num,  sizeof(int)*total_number, cudaMemcpyHostToDevice));
    CUDACHECK( cudaMemcpy(src_d->it_begin, src->it_begin, sizeof(int)*total_number, cudaMemcpyHostToDevice));
    CUDACHECK( cudaMemcpy(src_d->it_end,   src->it_end,   sizeof(int)*total_number, cudaMemcpyHostToDevice));
    CUDACHECK( cudaMemcpy(src_d->ext_indx, src->ext_indx, sizeof(int)*total_number*max_ext, cudaMemcpyHostToDevice));
    CUDACHECK( cudaMemcpy(src_d->ext_coef, src->ext_coef, sizeof(float)*total_number*max_ext, cudaMemcpyHostToDevice));
  }
  return 0;
}

int init_bdryfree_device(gd_t *gd, bdryfree_t *bdryfree, bdryfree_t *bdryfree_d)
{
  int nx = gd->nx;
  int ny = gd->ny;
  int nz = gd->nz;

  memcpy(bdryfree_d,bdryfree,sizeof(bdryfree_t));
  // copy bdryfree
  if (bdryfree_d->is_sides_free[CONST_NDIM-1][1] == 1)
  {
    bdryfree_d->matVx2Vz2 = (float *) cuda_malloc(sizeof(float)*nx*ny*CONST_NDIM*CONST_NDIM);
    bdryfree_d->matVy2Vz2 = (float *) cuda_malloc(sizeof(float)*nx*ny*CONST_NDIM*CONST_NDIM);
    bdryfree_d->matD      = (float *) cuda_malloc(sizeof(float)*nx*ny*CONST_NDIM*CONST_NDIM);

    CUDACHECK(cudaMemcpy(bdryfree_d->matVx2Vz2, bdryfree->matVx2Vz2, sizeof(float)*nx*ny*CONST_NDIM*CONST_NDIM, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(bdryfree_d->matVy2Vz2, bdryfree->matVy2Vz2, sizeof(float)*nx*ny*CONST_NDIM*CONST_NDIM, cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(bdryfree_d->matD, bdryfree->matD, sizeof(float)*nx*ny*CONST_NDIM*CONST_NDIM, cudaMemcpyHostToDevice));
  }

  return 0;
}

int init_bdrypml_device(gd_t *gd, bdrypml_t *bdrypml, bdrypml_t *bdrypml_d)
{
  int nx = gd->nx;
  int ny = gd->ny;
  int nz = gd->nz;

  // copy bdrypml
  memcpy(bdrypml_d,bdrypml,sizeof(bdrypml_t));
  if (bdrypml->is_enable_pml == 1)
  {
    for(int idim=0; idim<CONST_NDIM; idim++){
      for(int iside=0; iside<2; iside++){
        if(bdrypml_d->is_sides_pml[idim][iside] == 1){
          int npoints = bdrypml_d->num_of_layers[idim][iside] + 1;
          bdrypml_d->A[idim][iside]   = (float *) cuda_malloc(npoints * sizeof(float));
          bdrypml_d->B[idim][iside]   = (float *) cuda_malloc(npoints * sizeof(float));
          bdrypml_d->D[idim][iside]   = (float *) cuda_malloc(npoints * sizeof(float));
          CUDACHECK(cudaMemcpy(bdrypml_d->A[idim][iside],bdrypml->A[idim][iside],npoints*sizeof(float),cudaMemcpyHostToDevice));
          CUDACHECK(cudaMemcpy(bdrypml_d->B[idim][iside],bdrypml->B[idim][iside],npoints*sizeof(float),cudaMemcpyHostToDevice));
          CUDACHECK(cudaMemcpy(bdrypml_d->D[idim][iside],bdrypml->D[idim][iside],npoints*sizeof(float),cudaMemcpyHostToDevice));
          } else {
          bdrypml_d->A[idim][iside] = NULL;
          bdrypml_d->B[idim][iside] = NULL;
          bdrypml_d->D[idim][iside] = NULL;
        }
      }
    }

    for(int idim=0; idim<CONST_NDIM; idim++){
      for(int iside=0; iside<2; iside++){
        bdrypml_auxvar_t *auxvar_d = &(bdrypml_d->auxvar[idim][iside]);
        if(auxvar_d->siz_icmp > 0){
          auxvar_d->var = (float *) cuda_malloc(sizeof(float)*auxvar_d->siz_ilevel*auxvar_d->nlevel); 
          CUDACHECK(cudaMemset(auxvar_d->var,0,sizeof(float)*auxvar_d->siz_ilevel*auxvar_d->nlevel));
        } else {
        auxvar_d->var = NULL;
        }
      }
    }
  }

  return 0;
}

int init_bdryexp_device(gd_t *gd, bdryexp_t *bdryexp, bdryexp_t *bdryexp_d)
{
  int nx = gd->nx;
  int ny = gd->ny;
  int nz = gd->nz;

  // copy bdryexp
  memcpy(bdryexp_d,bdryexp,sizeof(bdryexp_t));
  if (bdryexp->is_enable_ablexp == 1)
  {
    bdryexp_d->ablexp_Ex = (float *) cuda_malloc(nx * sizeof(float));
    bdryexp_d->ablexp_Ey = (float *) cuda_malloc(ny * sizeof(float));
    bdryexp_d->ablexp_Ez = (float *) cuda_malloc(nz * sizeof(float));
    CUDACHECK(cudaMemcpy(bdryexp_d->ablexp_Ex,bdryexp->ablexp_Ex,nx*sizeof(float),cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(bdryexp_d->ablexp_Ey,bdryexp->ablexp_Ey,ny*sizeof(float),cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(bdryexp_d->ablexp_Ez,bdryexp->ablexp_Ez,nz*sizeof(float),cudaMemcpyHostToDevice));
  }

  return 0;
}

int init_wave_device(wav_t *wav, wav_t *wav_d)
{
  size_t siz_ilevel = wav->siz_ilevel;
  int nlevel = wav->nlevel;
  int nmaxwell = wav->nmaxwell;
  memcpy(wav_d,wav,sizeof(wav_t));
  wav_d->v5d   = (float *) cuda_malloc(sizeof(float)*siz_ilevel*nlevel);
  CUDACHECK(cudaMemset(wav_d->v5d,0,sizeof(float)*siz_ilevel*nlevel));

  if(wav->visco_type == CONST_VISCO_GMB)
  {
    wav_d->Jxx_pos = (size_t *) cuda_malloc(sizeof(size_t)*nmaxwell);
    wav_d->Jyy_pos = (size_t *) cuda_malloc(sizeof(size_t)*nmaxwell);
    wav_d->Jzz_pos = (size_t *) cuda_malloc(sizeof(size_t)*nmaxwell);
    wav_d->Jxy_pos = (size_t *) cuda_malloc(sizeof(size_t)*nmaxwell);
    wav_d->Jxz_pos = (size_t *) cuda_malloc(sizeof(size_t)*nmaxwell);
    wav_d->Jyz_pos = (size_t *) cuda_malloc(sizeof(size_t)*nmaxwell);
    CUDACHECK(cudaMemcpy(wav_d->Jxx_pos,wav->Jxx_pos,sizeof(size_t)*nmaxwell,cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(wav_d->Jyy_pos,wav->Jyy_pos,sizeof(size_t)*nmaxwell,cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(wav_d->Jzz_pos,wav->Jzz_pos,sizeof(size_t)*nmaxwell,cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(wav_d->Jxy_pos,wav->Jxy_pos,sizeof(size_t)*nmaxwell,cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(wav_d->Jxz_pos,wav->Jxz_pos,sizeof(size_t)*nmaxwell,cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(wav_d->Jyz_pos,wav->Jyz_pos,sizeof(size_t)*nmaxwell,cudaMemcpyHostToDevice));

    wav_d->Jxx_seq = (size_t *) cuda_malloc(sizeof(size_t)*nmaxwell);
    wav_d->Jyy_seq = (size_t *) cuda_malloc(sizeof(size_t)*nmaxwell);
    wav_d->Jzz_seq = (size_t *) cuda_malloc(sizeof(size_t)*nmaxwell);
    wav_d->Jxy_seq = (size_t *) cuda_malloc(sizeof(size_t)*nmaxwell);
    wav_d->Jxz_seq = (size_t *) cuda_malloc(sizeof(size_t)*nmaxwell);
    wav_d->Jyz_seq = (size_t *) cuda_malloc(sizeof(size_t)*nmaxwell);
    CUDACHECK(cudaMemcpy(wav_d->Jxx_seq,wav->Jxx_seq,sizeof(size_t)*nmaxwell,cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(wav_d->Jyy_seq,wav->Jyy_seq,sizeof(size_t)*nmaxwell,cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(wav_d->Jzz_seq,wav->Jzz_seq,sizeof(size_t)*nmaxwell,cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(wav_d->Jxy_seq,wav->Jxy_seq,sizeof(size_t)*nmaxwell,cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(wav_d->Jxz_seq,wav->Jxz_seq,sizeof(size_t)*nmaxwell,cudaMemcpyHostToDevice));
    CUDACHECK(cudaMemcpy(wav_d->Jyz_seq,wav->Jyz_seq,sizeof(size_t)*nmaxwell,cudaMemcpyHostToDevice));
  }

  return 0;
}

float *init_PGVAD_device(gd_t *gd)
{
  float *PG_d;
  int nx = gd->nx;
  int ny = gd->ny;
  PG_d = (float *) cuda_malloc(sizeof(float)*CONST_NDIM_5*nx*ny);
  CUDACHECK(cudaMemset(PG_d,0,sizeof(float)*CONST_NDIM_5*nx*ny));

  return PG_d;
}

float *init_Dis_accu_device(gd_t *gd)
{
  float *Dis_accu_d;
  int nx = gd->nx;
  int ny = gd->ny;
  Dis_accu_d = (float *) cuda_malloc(sizeof(float)*CONST_NDIM*nx*ny);
  CUDACHECK(cudaMemset(Dis_accu_d,0,sizeof(float)*CONST_NDIM*nx*ny));

  return Dis_accu_d;
}

int *init_neighid_device(int *neighid)
{
  int *neighid_d; 
  neighid_d = (int *) cuda_malloc(sizeof(int)*CONST_NDIM_2);
  CUDACHECK(cudaMemcpy(neighid_d,neighid,sizeof(int)*CONST_NDIM_2,cudaMemcpyHostToDevice));

  return neighid_d;
}

int dealloc_gd_device(gd_t gd_d)
{
  CUDACHECK(cudaFree(gd_d.x3d)); 
  CUDACHECK(cudaFree(gd_d.y3d)); 
  CUDACHECK(cudaFree(gd_d.z3d)); 
  CUDACHECK(cudaFree(gd_d.x1d)); 
  CUDACHECK(cudaFree(gd_d.y1d)); 
  CUDACHECK(cudaFree(gd_d.z1d)); 

  CUDACHECK(cudaFree(gd_d.cell_xmin)); 
  CUDACHECK(cudaFree(gd_d.cell_xmax)); 
  CUDACHECK(cudaFree(gd_d.cell_ymin)); 
  CUDACHECK(cudaFree(gd_d.cell_ymax)); 
  CUDACHECK(cudaFree(gd_d.cell_zmin)); 
  CUDACHECK(cudaFree(gd_d.cell_zmax)); 
  CUDACHECK(cudaFree(gd_d.tile_istart));
  CUDACHECK(cudaFree(gd_d.tile_iend));  
  CUDACHECK(cudaFree(gd_d.tile_jstart));
  CUDACHECK(cudaFree(gd_d.tile_jend));  
  CUDACHECK(cudaFree(gd_d.tile_kstart));
  CUDACHECK(cudaFree(gd_d.tile_kend));  
  CUDACHECK(cudaFree(gd_d.tile_xmin));
  CUDACHECK(cudaFree(gd_d.tile_xmax));
  CUDACHECK(cudaFree(gd_d.tile_ymin));
  CUDACHECK(cudaFree(gd_d.tile_ymax));
  CUDACHECK(cudaFree(gd_d.tile_zmin));
  CUDACHECK(cudaFree(gd_d.tile_zmax));  

  return 0;
}

int dealloc_md_device(md_t md_d)
{
  if (md_d.medium_type == CONST_MEDIUM_ACOUSTIC_ISO)
  {
    CUDACHECK(cudaFree(md_d.rho  )); 
    CUDACHECK(cudaFree(md_d.kappa)); 
  }
  if (md_d.medium_type == CONST_MEDIUM_ELASTIC_ISO)
  {
    CUDACHECK(cudaFree(md_d.rho   )); 
    CUDACHECK(cudaFree(md_d.lambda)); 
    CUDACHECK(cudaFree(md_d.mu    )); 
  }
  if (md_d.medium_type == CONST_MEDIUM_VISCOELASTIC_ISO)
  {
    CUDACHECK(cudaFree(md_d.rho   )); 
    CUDACHECK(cudaFree(md_d.lambda)); 
    CUDACHECK(cudaFree(md_d.mu    )); 
    if (md_d.visco_type == CONST_VISCO_GRAVES_QS) {
      CUDACHECK(cudaFree(md_d.Qs    )); 
    } else if(md_d.visco_type == CONST_VISCO_GMB) {
      CUDACHECK(cudaFree(md_d.Qp    )); 
      CUDACHECK(cudaFree(md_d.Qs    )); 
      for(int i=0; i<md_d.nmaxwell; i++)
      {
        CUDACHECK(cudaFree(md_d.Ylam[i])); 
        CUDACHECK(cudaFree(md_d.Ymu [i])); 
      }
    }
  }
  if (md_d.medium_type == CONST_MEDIUM_ELASTIC_VTI)
  {
    CUDACHECK(cudaFree(md_d.rho)); 
    CUDACHECK(cudaFree(md_d.c11)); 
    CUDACHECK(cudaFree(md_d.c33)); 
    CUDACHECK(cudaFree(md_d.c55)); 
    CUDACHECK(cudaFree(md_d.c66)); 
    CUDACHECK(cudaFree(md_d.c13)); 
  }
  if (md_d.medium_type == CONST_MEDIUM_ELASTIC_ANISO)
  {
    CUDACHECK(cudaFree(md_d.rho)); 
    CUDACHECK(cudaFree(md_d.c11)); 
    CUDACHECK(cudaFree(md_d.c12)); 
    CUDACHECK(cudaFree(md_d.c13)); 
    CUDACHECK(cudaFree(md_d.c14)); 
    CUDACHECK(cudaFree(md_d.c15)); 
    CUDACHECK(cudaFree(md_d.c16)); 
    CUDACHECK(cudaFree(md_d.c22)); 
    CUDACHECK(cudaFree(md_d.c23)); 
    CUDACHECK(cudaFree(md_d.c24)); 
    CUDACHECK(cudaFree(md_d.c25)); 
    CUDACHECK(cudaFree(md_d.c26)); 
    CUDACHECK(cudaFree(md_d.c33)); 
    CUDACHECK(cudaFree(md_d.c34)); 
    CUDACHECK(cudaFree(md_d.c35)); 
    CUDACHECK(cudaFree(md_d.c36)); 
    CUDACHECK(cudaFree(md_d.c44)); 
    CUDACHECK(cudaFree(md_d.c45)); 
    CUDACHECK(cudaFree(md_d.c46)); 
    CUDACHECK(cudaFree(md_d.c55)); 
    CUDACHECK(cudaFree(md_d.c56)); 
    CUDACHECK(cudaFree(md_d.c66)); 
  }

  return 0;
}

int dealloc_fd_device(fd_wav_t fd_wav_d)
{
  CUDACHECK(cudaFree(fd_wav_d.fdz_len_d));

  CUDACHECK(cudaFree(fd_wav_d.fdx_coef_d));
  CUDACHECK(cudaFree(fd_wav_d.fdy_coef_d));
  CUDACHECK(cudaFree(fd_wav_d.fdz_coef_d));
  CUDACHECK(cudaFree(fd_wav_d.fdz_coef_all_d));

  CUDACHECK(cudaFree(fd_wav_d.fdx_indx_d));
  CUDACHECK(cudaFree(fd_wav_d.fdy_indx_d));
  CUDACHECK(cudaFree(fd_wav_d.fdz_indx_d));
  CUDACHECK(cudaFree(fd_wav_d.fdz_indx_all_d));

  CUDACHECK(cudaFree(fd_wav_d.fdx_shift_d));
  CUDACHECK(cudaFree(fd_wav_d.fdy_shift_d));
  CUDACHECK(cudaFree(fd_wav_d.fdz_shift_d));
  CUDACHECK(cudaFree(fd_wav_d.fdz_shift_all_d));

  return 0;
}
int dealloc_metric_device(gd_metric_t metric_d)
{
  CUDACHECK(cudaFree(metric_d.jac   )); 
  CUDACHECK(cudaFree(metric_d.xi_x  )); 
  CUDACHECK(cudaFree(metric_d.xi_y  )); 
  CUDACHECK(cudaFree(metric_d.xi_z  )); 
  CUDACHECK(cudaFree(metric_d.eta_x )); 
  CUDACHECK(cudaFree(metric_d.eta_y )); 
  CUDACHECK(cudaFree(metric_d.eta_z )); 
  CUDACHECK(cudaFree(metric_d.zeta_x)); 
  CUDACHECK(cudaFree(metric_d.zeta_y)); 
  CUDACHECK(cudaFree(metric_d.zeta_z)); 
  return 0;
}

int dealloc_src_device(src_t src_d)
{
  if(src_d.force_actived == 1)
  {
    CUDACHECK(cudaFree(src_d.Fx)); 
    CUDACHECK(cudaFree(src_d.Fy)); 
    CUDACHECK(cudaFree(src_d.Fz)); 
  }
  if(src_d.moment_actived == 1)
  {
    CUDACHECK(cudaFree(src_d.Mxx)); 
    CUDACHECK(cudaFree(src_d.Myy)); 
    CUDACHECK(cudaFree(src_d.Mzz)); 
    CUDACHECK(cudaFree(src_d.Mxz)); 
    CUDACHECK(cudaFree(src_d.Myz)); 
    CUDACHECK(cudaFree(src_d.Mxy)); 
  }
  if(src_d.total_number > 0)
  {
    CUDACHECK(cudaFree(src_d.ext_num )); 
    CUDACHECK(cudaFree(src_d.ext_indx)); 
    CUDACHECK(cudaFree(src_d.ext_coef)); 
    CUDACHECK(cudaFree(src_d.it_begin)); 
    CUDACHECK(cudaFree(src_d.it_end  )); 
  }
  return 0;
}

int dealloc_bdryfree_device(bdryfree_t bdryfree_d)
{
  if (bdryfree_d.is_sides_free[CONST_NDIM-1][1] == 1)
  {
    CUDACHECK(cudaFree(bdryfree_d.matVx2Vz2)); 
    CUDACHECK(cudaFree(bdryfree_d.matVy2Vz2)); 
    CUDACHECK(cudaFree(bdryfree_d.matD)); 
  }
  return 0;
}

int dealloc_bdrypml_device(bdrypml_t bdrypml_d)
{
  if(bdrypml_d.is_enable_pml == 1)
  {
    for(int idim=0; idim<CONST_NDIM; idim++){
      for(int iside=0; iside<2; iside++){
        if(bdrypml_d.is_sides_pml[idim][iside] == 1){
          CUDACHECK(cudaFree(bdrypml_d.A[idim][iside])); 
          CUDACHECK(cudaFree(bdrypml_d.B[idim][iside])); 
          CUDACHECK(cudaFree(bdrypml_d.D[idim][iside])); 
        }
      }
    }  
    for(int idim=0; idim<CONST_NDIM; idim++){
      for(int iside=0; iside<2; iside++){
        bdrypml_auxvar_t *auxvar_d = &(bdrypml_d.auxvar[idim][iside]);
        if(auxvar_d->siz_icmp > 0){
          CUDACHECK(cudaFree(auxvar_d->var)); 
        }
      }
    }  
  }

  return 0;
}

int dealloc_bdryexp_device(bdryexp_t bdryexp_d)
{
  if(bdryexp_d.is_enable_ablexp == 1)
  {
    CUDACHECK(cudaFree(bdryexp_d.ablexp_Ex)); 
    CUDACHECK(cudaFree(bdryexp_d.ablexp_Ey));
    CUDACHECK(cudaFree(bdryexp_d.ablexp_Ez));
  }

  return 0;
}

int dealloc_wave_device(wav_t wav_d)
{
  CUDACHECK(cudaFree(wav_d.v5d)); 
  if(wav_d.visco_type == CONST_VISCO_GMB)
  {
    CUDACHECK(cudaFree(wav_d.Jxx_pos)); 
    CUDACHECK(cudaFree(wav_d.Jyy_pos)); 
    CUDACHECK(cudaFree(wav_d.Jzz_pos)); 
    CUDACHECK(cudaFree(wav_d.Jxy_pos)); 
    CUDACHECK(cudaFree(wav_d.Jxz_pos)); 
    CUDACHECK(cudaFree(wav_d.Jyz_pos)); 
    CUDACHECK(cudaFree(wav_d.Jxx_seq)); 
    CUDACHECK(cudaFree(wav_d.Jyy_seq)); 
    CUDACHECK(cudaFree(wav_d.Jzz_seq)); 
    CUDACHECK(cudaFree(wav_d.Jxy_seq)); 
    CUDACHECK(cudaFree(wav_d.Jxz_seq)); 
    CUDACHECK(cudaFree(wav_d.Jyz_seq)); 
  }
  return 0;
}
